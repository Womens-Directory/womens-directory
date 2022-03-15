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
  has_paper_trail
  strips_spaces_from_string_fields

  def to_s
    "Phone #{id}: #{name || '<no name>'} #{flags_desc}".strip
  end

  private

  def flags_desc
    flags = {
      'call': call,
      'SMS': sms,
      '24/7': always_open,
    }.filter { |_, v| v }.map { |k, v| k }
    return '' if flags.empty?
    return "(#{flags.join(', ')})"
  end
end

# can you show me the data going into these methods and where they are fro 
# i don't understand how the interface/admin forms work, only used to coding with params[x]
