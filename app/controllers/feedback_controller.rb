class FeedbackController < ApplicationController
  def save
    p = request.params
    f = Feedback.create!(
      path: p['path'],
      category: p['category'],
      body: p['body'],
      ip: request.remote_ip,
    )
    ahoy.track :feedback_submitted, feedback_id: f.id
    render plain: '', status: :no_content
  end
end
