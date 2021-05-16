class ApplicationMailer < ActionMailer::Base
  default from: "app@#{ENV['EMAIL_DOMAIN']}"
  layout 'mailer'
end
