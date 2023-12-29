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

		def generate_report!(user, start_date, end_date)
			raise ArgumentError, "start_date must be before end_date" if start_date > end_date
			report = AnalyticsReport.create! user: user, start_date: start_date, end_date: end_date
			GenerateReportJob.perform_later report.id
			return report.id
		end

		def calculate_report_data(start_date, end_date)
			visits = meaningful_visits.where(started_at: start_date..end_date).includes(:events)
			visit_count_by_date = visits.pluck(:started_at).group_by { |d| d.to_date }.map { |k, v| [k.iso8601, v.count] }.to_h

			total_views = {
				location: Hash.new(0),
				cat_loc: Hash.new(0),
				cat: Hash.new(0),
				org: Hash.new(0),
				cms_page: Hash.new(0),
			}
			event_count = 0
			event_types = Hash.new 0
			visits.find_each(batch_size: 100) do |visit|
				visit.events.each do |event|
					event_count += 1
					event_types[event.name] += 1
					if event.location_id
						total_views[:location][event.location_id] += 1
						if event.category_id
							total_views[:cat_loc][event.category_id] += 1
						end
					elsif event.category_id
						total_views[:cat][event.category_id] += 1
					elsif event.org_id
						total_views[:org][event.org_id] += 1
					elsif event.comfy_cms_page_id
						total_views[:cms_page][event.comfy_cms_page_id] += 1
					end
				end
			end

			by_visit = {
				location: Hash.new(0),
				cat_loc: Hash.new(0),
				cat: Hash.new(0),
				org: Hash.new(0),
				cms_page: Hash.new(0),
			}
			visits.find_each(batch_size: 100) do |visit|
				visited_locations = Set.new
				visited_cat_locs = Set.new
				visited_cats = Set.new
				visited_orgs = Set.new
				visited_cms_pages = Set.new

				visit.events.each do |event|
					if event.location_id
						visited_locations << event.location_id
						if event.category_id
							visited_cat_locs << event.category_id
						end
					elsif event.category_id
						visited_cats << event.category_id
					elsif event.org_id
						visited_orgs << event.org_id
					elsif event.comfy_cms_page_id
						visited_cms_pages << event.comfy_cms_page_id
					end
				end

				visited_locations.each { |id| by_visit[:location][id] += 1 }
				visited_cat_locs.each { |id| by_visit[:cat_loc][id] += 1 }
				visited_cats.each { |id| by_visit[:cat][id] += 1 }
				visited_orgs.each { |id| by_visit[:org][id] += 1 }
				visited_cms_pages.each { |id| by_visit[:cms_page][id] += 1 }
			end

			by_visitor = {
				location: Hash.new(0),
				cat_loc: Hash.new(0),
				cat: Hash.new(0),
				org: Hash.new(0),
				cms_page: Hash.new(0),
			}
			visits.pluck(:visitor_token).uniq.each do |visitor_token|
				visited_locations = Set.new
				visited_cat_locs = Set.new
				visited_cats = Set.new
				visited_orgs = Set.new
				visited_cms_pages = Set.new

				visits.where(visitor_token: visitor_token).find_each(batch_size: 100) do |visit|
					visit.events.each do |event|
						if event.location_id
							visited_locations << event.location_id
							if event.category_id
								visited_cat_locs << event.category_id
							end
						elsif event.category_id
							visited_cats << event.category_id
						elsif event.org_id
							visited_orgs << event.org_id
						elsif event.comfy_cms_page_id
							visited_cms_pages << event.comfy_cms_page_id
						end
					end
				end

				visited_locations.each { |id| by_visitor[:location][id] += 1 }
				visited_cat_locs.each { |id| by_visitor[:cat_loc][id] += 1 }
				visited_cats.each { |id| by_visitor[:cat][id] += 1 }
				visited_orgs.each { |id| by_visitor[:org][id] += 1 }
				visited_cms_pages.each { |id| by_visitor[:cms_page][id] += 1 }
			end

			{
				visit_count: visits.count,
				visit_count_by_date: visit_count_by_date,
				event_count: event_count,
				event_types: event_types,
				total_views: total_views,
				views_by_visit: by_visit,
				views_by_visitor: by_visitor,
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
			start = Time.now
			data = Analytics.calculate_report_data report.start_date, report.end_date
			duration = Time.now - start
			report.update! data: data, report_generation_duration: duration
		end
	end
end
