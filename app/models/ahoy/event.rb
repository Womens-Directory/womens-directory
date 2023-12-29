# == Schema Information
#
# Table name: ahoy_events
#
#  id                :bigint           not null, primary key
#  name              :string
#  properties        :jsonb
#  time              :datetime
#  category_id       :bigint
#  comfy_cms_page_id :bigint
#  feedback_id       :bigint
#  location_id       :bigint
#  org_id            :bigint
#  user_id           :bigint
#  visit_id          :bigint
#
# Indexes
#
#  index_ahoy_events_on_category_id        (category_id)
#  index_ahoy_events_on_comfy_cms_page_id  (comfy_cms_page_id)
#  index_ahoy_events_on_feedback_id        (feedback_id)
#  index_ahoy_events_on_location_id        (location_id)
#  index_ahoy_events_on_name_and_time      (name,time)
#  index_ahoy_events_on_org_id             (org_id)
#  index_ahoy_events_on_properties         (properties) USING gin
#  index_ahoy_events_on_user_id            (user_id)
#  index_ahoy_events_on_visit_id           (visit_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (comfy_cms_page_id => comfy_cms_pages.id)
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
  belongs_to :comfy_cms_page, class_name: 'Comfy::Cms::Page', optional: true

  def associate
    properties.each do |k, v|
      if k.ends_with? '_id'
        properties.delete k
        send "#{k}=".to_sym, v
      end
    end
  end
end
