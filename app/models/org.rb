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
  include PgSearch::Model

  # TODO: Make hideable
  has_many :locations, dependent: :destroy
  has_many :events, class_name: 'Ahoy::Event', dependent: :destroy
  has_one :submission, as: :owner
  validates_presence_of :desc, :name, :website
  has_paper_trail
  strips_spaces_from_string_fields
  multisearchable against: %i[desc name website]

  def to_s
    "Org #{id}: #{name}"
  end

  def to_param
    "#{id}-#{name_as_slug}"
  end
end
