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
require 'rails_helper'

RSpec.describe Volunteer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
