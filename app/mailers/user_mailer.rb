class UserMailer < ApplicationMailer
  def welcome(user)
    @greeting = "Hi"
    mail to: user.email
  end
end
