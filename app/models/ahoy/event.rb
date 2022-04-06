# reviewed with ML
# == Schema Information
#
# Table name: ahoy_events
#
#  id          :bigint           not null, primary key
#  name        :string
#  properties  :jsonb # format to store data
#  time        :datetime
#  category_id :bigint
#  feedback_id :bigint
#  location_id :bigint
#  org_id      :bigint
#  user_id     :bigint
#  visit_id    :bigint
#
# Indexes
#
#  index_ahoy_events_on_category_id    (category_id)
#  index_ahoy_events_on_feedback_id    (feedback_id)
#  index_ahoy_events_on_location_id    (location_id)
#  index_ahoy_events_on_name_and_time  (name,time)
#  index_ahoy_events_on_org_id         (org_id)
#  index_ahoy_events_on_properties     (properties) USING gin
#  index_ahoy_events_on_user_id        (user_id)
#  index_ahoy_events_on_visit_id       (visit_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (feedback_id => feedbacks.id)
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (org_id => orgs.id)
#
class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods
  before_validation :associate

  self.table_name = "ahoy_events"

  belongs_to :visit

  belongs_to :category, optional: true
  belongs_to :feedback, optional: true
  belongs_to :location, optional: true
  belongs_to :org, optional: true
  belongs_to :user, optional: true

  # this method pulls any id for other models out of the properties hash and then turns them into real Rails associations in the database
  def associate
    properties.each do |k, v|
      if k.ends_with? '_id'
        properties.delete k
        send "#{k}=".to_sym, v
      end
    end
  end
end

# in digitalocean console, type: Ahoy::Events.where.not(category: nil).first
# and then Ahoy::Event.where.not(category: nil).first, the not nil category
# returns => #<Ahoy::Event id: 1, visit_id: 1, user_id: nil, name: "category_viewed", properties: {}, time: "2021-06-19 20:05:24.788742000 +0000", category_id: 8, feedback_id: nil, location_id: nil, org_id: nil>
# irb(main):013:0> _.category
#<Category id: 8, name: "Child Care and Early Education", created_at: "2021-04-25 23:10:01.856109000 +0000", updated_at: "2021-07-25 16:30:57.096075000 +0000", description: "Resources for women who need help getting access t...", visible: true>
# each event has a name and properties in ahoy (properties = jsonb) what is jsonb?
