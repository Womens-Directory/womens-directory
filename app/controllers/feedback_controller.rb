class FeedbackController < ApplicationController
  include Notifiable

  def save
    p = request.params
    f = Feedback.create!(
      path: p['path'],
      category: p['category'],
      body: p['body'],
      ip: request.remote_ip,
    )
    notify_new_feedback f
    render plain: '', status: :no_content
  end
end
