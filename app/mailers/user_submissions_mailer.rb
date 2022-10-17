class UserSubmissionsMailer < ApplicationMailer
  def confirm(submission)
    @records = submission.targets
    @confirmation_token = submission.confirmation_token
    mail from: 'confirm@womensdirectory.org', to: submission.contact_email, subject: "Confirm your submission"
  end
end
