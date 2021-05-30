# == Schema Information
#
# Table name: phone_numbers
#
#  id          :bigint           not null, primary key
#  always_open :boolean          default(FALSE), not null
#  call        :boolean          default(FALSE), not null
#  name        :string
#  number      :string           not null
#  sms         :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :bigint
#
# Indexes
#
#  index_phone_numbers_on_location_id  (location_id)
#
class PhoneNumber < ApplicationRecord
  belongs_to :location
  validates_presence_of :number
  strips_spaces_from_string_fields
end
