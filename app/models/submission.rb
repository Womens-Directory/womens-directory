# == Schema Information
#
# Table name: submissions
#
#  id                 :bigint           not null, primary key
#  additional_notes   :text             default(""), not null
#  confirmation_token :string           not null
#  confirmed          :boolean          default(FALSE), not null
#  contact_email      :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_submissions_on_contact_email  (contact_email)
#
class Submission < ApplicationRecord
  has_one :location
  has_one :org
  # TODO: destroy old submissions at expiry period

  def targets
    # Targets are ordered by dependency, e.g. you cannot create a Location unless its Org already exists
    [org, location].compact
  end

  def primary_target
    targets.first
  end

  def can_confirm_now?(target)
    target == primary_target
  end

  def reject!(reason)
    ApplicationRecord.transaction do
      ce = contact_email
      records = targets
      targets.each(&:destroy!)
      destroy!
      UserSubmissionsMailer.reject(ce, records, reason).deliver_now
    end
  end
end
