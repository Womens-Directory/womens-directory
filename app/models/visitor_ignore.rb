# == Schema Information
#
# Table name: visitor_ignores
#
#  id                     :bigint           not null, primary key
#  visitor_token          :string           not null
#  visitor_ignore_rule_id :bigint           not null
#
# Indexes
#
#  index_visitor_ignores_on_visitor_ignore_rule_id  (visitor_ignore_rule_id)
#
# Foreign Keys
#
#  fk_rails_...  (visitor_ignore_rule_id => visitor_ignore_rules.id)
#
class VisitorIgnore < ApplicationRecord
	belongs_to :visitor_ignore_rule
end
