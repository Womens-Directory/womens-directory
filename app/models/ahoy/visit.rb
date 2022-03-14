# == Schema Information
#
# Table name: ahoy_visits
#
#  id               :bigint           not null, primary key
#  app_version      :string
#  browser          :string
#  city             :string
#  country          :string
#  device_type      :string
#  ip               :string
#  landing_page     :text
#  latitude         :float
#  longitude        :float
#  os               :string
#  os_version       :string
#  platform         :string
#  referrer         :text
#  referring_domain :string
#  region           :string
#  started_at       :datetime
#  user_agent       :text
#  utm_campaign     :string
#  utm_content      :string
#  utm_medium       :string
#  utm_source       :string
#  utm_term         :string
#  visit_token      :string
#  visitor_token    :string
#  user_id          :bigint
#
# Indexes
#
#  index_ahoy_visits_on_user_id      (user_id)
#  index_ahoy_visits_on_visit_token  (visit_token) UNIQUE
#


class ClearIpJob < ActiveJob::Base
# delete the ip address for that visit
# what is ActiveJob? https://api.rubyonrails.org/classes/ActiveJob/Base.html
  def perform(visit)
    visit.update! ip: nil
  end
end

class Ahoy::Visit < ApplicationRecord
  self.table_name = "ahoy_visits"

  has_many :events, class_name: "Ahoy::Event"
  belongs_to :user, optional: true

  after_create :clear_ip

  # what does optional: true do? associated object won't be validated? what is associated object why not validate?

  def clear_ip
    # Must wait a little bit before clearing the IP so that the visit can be geocoded
    ClearIpJob.set(wait: 5.seconds).perform_later(self)
  end
end

# why are two classes in one file?
# ActiveJob:https://api.rubyonrails.org/classes/ActiveJob/Base.html what does it do?
# what are the indexes and how are they used?
# when to use ApplicationRecord and ActiveRecord::Base, what is the diff?
# what is an abstract class?
# how does .set method work? where find docs
