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
  # how does above line work, destroy is supposed to destroy the associated objects of what? and what are the associated objects?
  validates_presence_of :name
  has_paper_trail
  # from paper_trail gem, Add has_paper_trail to the models you want to track., https://github.com/paper-trail-gem/paper_trail
  # why track versions of models?
  strips_spaces_from_string_fields
  # you can just write a method here, it doesn't have to be attached to an oject?
  multisearchable against: %i[description name]
  # method in PgSearch https://github.com/Casecommons/pg_search, To add a model to the global search index for your application, call multisearchable in its class definition.

  def to_s
    "Category #{id}: #{name}"
  end

  def to_param
    "#{id}-#{name_as_slug}"
  end
  # where is this method used/called? when search code it is not used anywhere?


  private

  def name_as_slug
    name.downcase.gsub /[^-A-Za-z0-9]+/, '-'
  end
end
