module Submittable
  extend ActiveSupport::Concern

  def check_and_unlink_submission
    yield and return unless visible? # Once a submitted record has been made visible, we have accepted it.
    yield and return unless submission?

    s = submission
    submitter_email = s.contact_email

    ApplicationRecord.transaction do
      # Unlink the record from the submission.
      assign_attributes submission: nil if visible?

      yield # save record

      # We do not need the submission once we have accepted all of its records.
      s.destroy! if s.reload.targets.empty?

      # Let the user know we have accepted their submission.
      UserSubmissionsMailer.accept(submitter_email, self).deliver_now
    end
  end
end
