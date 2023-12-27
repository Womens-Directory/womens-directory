# == Schema Information
#
# Table name: visitor_ignore_rules
#
#  id         :bigint           not null, primary key
#  pattern    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class VisitorIgnoreRule < ApplicationRecord
	has_many :visitor_ignores

	def name
		pattern
	end
end
