# == Schema Information
#
# Table name: locations
#
#  id            :bigint           not null, primary key
#  address1      :string
#  address2      :string
#  city          :string           not null
#  desc          :text             not null
#  latitude      :decimal(9, 6)
#  longitude     :decimal(9, 6)
#  name          :string           not null
#  neighborhood  :string
#  state         :string           not null
#  visible       :boolean          default(FALSE), not null
#  website       :string
#  zip           :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  org_id        :bigint           not null
#  submission_id :bigint
#
# Indexes
#
#  index_locations_on_org_id         (org_id)
#  index_locations_on_submission_id  (submission_id)
#
# Foreign Keys
#
#  fk_rails_...  (org_id => orgs.id)
#  fk_rails_...  (submission_id => submissions.id)
#
require 'rails_helper'

RSpec.describe Location, type: :model do
  it "has many categories and belongs to an org" do
    planned_parenthood = Org.create!(
      name: "Planned Parenthood", desc: "A nonprofit that provides sexual health care",
      website: "https://www.plannedparenthood.org/")
    birth_control = Category.create!(name: "Birth Control")
    abortion = Category.create!(name: "Abortion")
    denver_central = Location.create!(
      city: "Denver", state: "CO", zip: "80222",
      desc: "Accepts walk-ins", name: "Denver Central",
      categories: [birth_control, abortion], org: planned_parenthood)

    expect(Location.count).to eql 1
    expect(Location.last.categories).to contain_exactly birth_control, abortion
    expect(Location.last.org).to eql planned_parenthood
  end
end
