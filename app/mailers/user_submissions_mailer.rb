class UserSubmissionsMailer < ApplicationMailer
  FROM = 'submissions@womensdirectory.org'

  def confirm(submission)
    @records = submission.targets
    @confirmation_token = submission.confirmation_token
    mail from: FROM, to: submission.contact_email, subject: "Confirm your submission"
  end

  def reject(submission, record, reason)
    @desc = "#{record.class.to_s.downcase} \"#{record.name}\""
    @reason = reason
    mail from: FROM, to: submission.contact_email, subject: 'Submission declined'
  end
end
