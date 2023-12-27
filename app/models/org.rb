# == Schema Information
#
# Table name: orgs
#
#  id            :bigint           not null, primary key
#  desc          :text             not null
#  name          :string           not null
#  visible       :boolean          default(FALSE), not null
#  website       :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  submission_id :bigint
#
# Indexes
#
#  index_orgs_on_submission_id  (submission_id)
#
# Foreign Keys
#
#  fk_rails_...  (submission_id => submissions.id)
#
class Org < ApplicationRecord
  include PgSearch::Model
  include Submittable

  belongs_to :submission, optional: true
  around_save :check_and_unlink_submission
  has_many :locations, dependent: :destroy
  has_many :events, class_name: 'Ahoy::Event', dependent: :destroy
  validates_presence_of :desc, :name, :website
  has_paper_trail
  strips_spaces_from_string_fields
  multisearchable against: %i[desc name website]

  scope :visible, -> { where(visible: true) }

  def to_s
    "Org #{id}: #{name}"
  end

  def to_param
    "#{id}-#{name_as_slug}"
  end

  def to_report_summary
    {
      id: id,
      name: name,
      desc: desc,
      link: Rails.application.routes.url_helpers.show_org_path(self),
      website: website,
    }
  end
end
