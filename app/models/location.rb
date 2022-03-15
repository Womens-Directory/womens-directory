# == Schema Information
#
# Table name: locations
#
#  id           :bigint           not null, primary key
#  address1     :string
#  address2     :string
#  city         :string           not null
#  desc         :text             not null
#  latitude     :decimal(9, 6)
#  longitude    :decimal(9, 6)
#  name         :string           not null
#  neighborhood :string
#  state        :string           not null
#  visible      :boolean          default(FALSE), not null
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
  include PgSearch::Model

  belongs_to :org
  has_and_belongs_to_many :categories
  has_many :phone_numbers, dependent: :destroy
  has_many :emails, dependent: :destroy
  has_many :events, class_name: 'Ahoy::Event', dependent: :destroy
  validates_presence_of :city, :desc, :name, :state, :zip
  has_paper_trail
  strips_spaces_from_string_fields
  multisearchable against: %i[address1 address2 city desc name neighborhood state website zip]
  # tells PgSearch what to search in database
  attr_accessor :distance
  # why is distance an attr_accessor as opposed to other attributes?

  # ? why not have dependent: :destroy on category?

  # return website without https in front
  def website_without_protocol
    match = /https?:\/\/(.+)/.match website
    return website unless match
    match[1]
  end

  # makes full address into a string
  def full_address
    [address1, address2, city, state, zip].select { |x| x }.join ', '
  end

  def full_address_with_name
    [name, full_address].join ', '
  end

  def to_s
    "Location #{id}: #{name}"
  end

  def to_param
    "#{id}-#{name_as_slug}"
  end

  # where are to_s

  # Don't break development apps when we're making fake locations locally
  if Rails.env.production?
    after_validation :geocode
    geocoded_by :full_address do |obj, results|
      if result = results[0]
        obj.latitude = result.data['geometry']['location']['lat']
        obj.longitude = result.data['geometry']['location']['lng']
        if !obj.neighborhood  # don't overwrite a neighborhood if we already set one manually
          ngh_data = result.data['address_components'].find { |c| c['types'].include? 'neighborhood' }
          obj.neighborhood = ngh_data['short_name'] if ngh_data
        end
      end
    end
  end
end

# need help reading last method, where does production? and .data methods come from?
