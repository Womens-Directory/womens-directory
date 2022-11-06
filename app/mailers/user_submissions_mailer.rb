class UserSubmissionsMailer < ApplicationMailer
  FROM = 'submissions@womensdirectory.org'

  def confirm(submission)
    @records = submission.targets
    @confirmation_token = submission.confirmation_token
    mail from: FROM, to: submission.contact_email, subject: "Confirm your submission"
  end

  def reject(submitter_email, records, reason)
    @records = records
    @reason = reason
    mail from: FROM, to: submitter_email, subject: 'Submission declined'
  end

  def accept(submitter_email, record)
    @desc = "#{record.class}: #{record.name}"
    @link = Route.show_url_for record
    mail from: FROM, to: submitter_email, subject: 'Submission accepted'
  end
end
