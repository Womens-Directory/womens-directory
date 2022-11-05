module Submittable
  extend ActiveSupport::Concern

  def check_and_unlink_submission
    yield and return unless visible? # Once a submitted record has been made visible, we have accepted it.
    yield and return unless submission?

    s = submission
    submitter_email = s.contact_email

    ApplicationRecord.transaction do
      assign_attributes submission: nil if visible? # unlink
      yield # save record
      s.destroy! if s.reload.targets.empty? # We do not need the submission once we have accepted all of its records.
      UserSubmissionsMailer.accept(submitter_email, self).deliver_now
    end
  end
end
