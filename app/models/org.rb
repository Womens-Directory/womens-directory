# == Schema Information
#
# Table name: orgs
#
#  id         :bigint           not null, primary key
#  desc       :text             not null
#  name       :string           not null
#  website    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Org < ApplicationRecord
  has_many :locations, dependent: :destroy
  validates_presence_of :desc, :name, :website
  strips_spaces_from_string_fields

  def to_s
    "#<Org #{id}: #{name}>"
  end

  def to_param
    "#{id}-#{name_as_slug}"
  end
end
