class FeedbackController < ApplicationController
  def save
    p = request.params
    Feedback.create!(
      path: p['path'],
      category: p['category'],
      body: p['body'],
      ip: request.remote_ip,
    )
    render plain: '', status: :no_content
  end
end
