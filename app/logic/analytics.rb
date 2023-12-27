module Analytics
	class << self
		def meaningful_visits
			Ahoy::Visit.
				where(user: nil).
				where.not(visitor_token: VisitorIgnore.select(:visitor_token))
		end

		def matching_rule_id(path)
			rule = rules.find { |r| path.match?(Regexp.new(r[1])) }
			return nil unless rule
			return rule[0]
		end

		def ignore_visitor(visitor_token, rule_id)
			vi = VisitorIgnore.find_or_initialize_by visitor_token: visitor_token
			if vi.new_record?
				vi.visitor_ignore_rule_id = rule_id
				result = vi.save
				if result
					return vi
				else
					Rails.logger.error "Failed to save VisitorIgnore: #{vi}: #{vi.errors.full_messages}"
				end
			end
			nil
		end

		def ignore_visitor_if_bot(visitor_token, path)
			rule_id = matching_rule_id(path)
			ignore_visitor visitor_token, rule_id if rule_id
		end

		def backfill_existing_visits
			count = 0
			meaningful_visits.find_each(batch_size: 100) do |visit|
				row = ignore_visitor_if_bot visit.visitor_token, visit.landing_page
				if row
					Rails.logger.info "Ignored #{row.visitor_token}: #{row.visitor_ignore_rule.pattern}"
					count += 1
				end
			end
			count
		end

		def generate_report(start_date, end_date)
			raise ArgumentError, "start_date must be before end_date" if start_date > end_date
			report = AnalyticsReport.create! start_date: start_date, end_date: end_date
			GenerateReportJob.perform_later report.id
			return report.id
		end

		def calculate_report_data(start_date, end_date)
			event_types = Hash.new 0
			location_views = Hash.new 0
			cat_loc_views = Hash.new 0
			cat_views = Hash.new 0
			org_views = Hash.new 0
			cms_page_views = Hash.new 0

			visits = meaningful_visits.where(started_at: start_date..end_date).includes(:events)
			event_count = 0
			visits.find_each(batch_size: 100) do |visit|
				visit.events.each do |event|
					event_count += 1
					event_types[event.name] += 1
					if event.location_id
						location_views[event.location_id] += 1
						if event.category_id
							cat_loc_views[event.category_id] += 1
						end
					elsif event.category_id
						cat_views[event.category_id] += 1
					elsif event.org_id
						org_views[event.org_id] += 1
					elsif event.comfy_cms_page_id
						cms_page_views[event.comfy_cms_page_id] += 1
					end
				end
			end

			{
				visit_count: visits.count,
				event_count: event_count,
				event_types: event_types,
				views_by_id: {
					location: location_views,
					cat_loc: cat_loc_views,
					cat: cat_views,
					org: org_views,
					cms_page: cms_page_views,
				}
			}
		end

		private

		def rules
			Rails.cache.fetch("visitor_ignore_rules", expires_in: 5.minutes) do
				VisitorIgnoreRule.all.pluck(:id, :pattern).map do |id, pattern|
					[id, Regexp.new(pattern)]
				end
			end
		end
	end

	class IgnoreVisitorJob < ActiveJob::Base
		def perform(visitor_token, path)
			Analytics.ignore_visitor_if_bot visitor_token, path
		end
	end

	class GenerateReportJob < ActiveJob::Base
		def perform(report_id)
			report = AnalyticsReport.find report_id
			data = Analytics.calculate_report_data report.start_date, report.end_date
			report.update! data: data
		end
	end
end
