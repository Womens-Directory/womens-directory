# == Schema Information
#
# Table name: volunteers
#
#  id             :bigint           not null, primary key
#  email          :string
#  first_name     :string
#  hours_per_week :integer
#  last_name      :string
#  phone          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Volunteer < ApplicationRecord
end
