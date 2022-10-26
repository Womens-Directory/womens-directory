# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  visible     :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Category < ApplicationRecord
  include PgSearch::Model

  has_and_belongs_to_many :locations
  has_many :events, class_name: 'Ahoy::Event', dependent: :destroy
  validates_presence_of :name
  has_paper_trail
  strips_spaces_from_string_fields
  multisearchable against: %i[description name]

  scope :visible, -> { where(visible: true) }

  def to_s
    "Category #{id}: #{name}"
  end

  def to_param
    "#{id}-#{name_as_slug}"
  end

  private

  def name_as_slug
    name.downcase.gsub /[^-A-Za-z0-9]+/, '-'
  end
end
