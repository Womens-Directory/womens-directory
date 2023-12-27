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
			Ahoy::Visit.find_each(batch_size: 100) do |visit|
				row = ignore_visitor_if_bot visit.visitor_token, visit.landing_page
				Rails.logger.info "Ignored #{row.visitor_token}: #{row.visitor_ignore_rule.pattern}" if row
			end
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
end
