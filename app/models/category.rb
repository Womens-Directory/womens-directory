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

  def to_s
    "#<Category #{id}: #{name}>"
  end
end
