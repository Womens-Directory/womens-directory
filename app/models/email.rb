# == Schema Information
#
# Table name: emails
#
#  id          :bigint           not null, primary key
#  address     :string           not null
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :bigint           not null
#
# Indexes
#
#  index_emails_on_location_id  (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
class Email < ApplicationRecord
  belongs_to :location
  validates :address, presence: true, format: { with: /@.+\./ }
end
# why need format for emails? what happens if you don't have this?
