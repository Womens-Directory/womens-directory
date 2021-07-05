class FeedbackController < ApplicationController
  include Notifiable

  def save
    p = request.params
    binding.pry
    f = Feedback.create!(
      path: p['path'],
      category: p['category'],
      body: p['body'],
      visit: current_visit,
    )
    notify_new_feedback f
    ahoy.track :feedback_submitted, feedback_id: f.id
    render plain: '', status: :no_content
  end
end
