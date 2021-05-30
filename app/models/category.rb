# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Category < ApplicationRecord
  has_and_belongs_to_many :locations
  validates_presence_of :name
  strips_spaces_from_string_fields

  def to_s
    "#<Category #{id}: #{name}>"
  end

  def to_param
    "#{id}-#{name_as_slug}"
  end

  private

  def name_as_slug
    name.downcase.gsub /[^-A-Za-z0-9]+/, '-'
  end
end
