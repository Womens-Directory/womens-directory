# == Schema Information
#
# Table name: phone_numbers
#
#  id          :bigint           not null, primary key
#  always_open :boolean          default(FALSE), not null
#  call        :boolean          default(FALSE), not null
#  number      :string           not null
#  sms         :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class PhoneNumber < ApplicationRecord
end
