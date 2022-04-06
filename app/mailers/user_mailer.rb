class UserMailer < ApplicationMailer
  def welcome(user)
    mail from: 'signin@womensdirectory.org', to: user.email
  end
end
