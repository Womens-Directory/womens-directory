# == Schema Information
#
# Table name: locations
#
#  id           :bigint           not null, primary key
#  address1     :string
#  address2     :string
#  city         :string           not null
#  desc         :text             not null
#  latitude     :float
#  longitude    :float
#  name         :string           not null
#  neighborhood :string
#  state        :string           not null
#  website      :string
#  zip          :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  org_id       :bigint           not null
#
# Indexes
#
#  index_locations_on_org_id  (org_id)
#
# Foreign Keys
#
#  fk_rails_...  (org_id => orgs.id)
#
class Location < ApplicationRecord
  belongs_to :org
  has_and_belongs_to_many :categories
  validates_presence_of :city, :desc, :name, :state, :zip

  def website_without_protocol
    match = /https?:\/\/(.+)/.match website
    return website unless match
    match[1]
  end

  after_validation :geocode
  geocoded_by :full_address do |obj, results|
    if result = results[0]
      ngh_data = result.data['address_components'].find { |c| c['types'].include? 'neighborhood' }
      obj.neighborhood = ngh_data['short_name'] if ngh_data
    end
  end

  def full_address
    [address1, address2, city, state, zip].join ', '
  end
end
