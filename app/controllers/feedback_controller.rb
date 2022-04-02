class FeedbackController < ApplicationController
  include Notifiable
  # notifiable module has logic to allow feedback from users of website to notify team in Discord

  # saves the feedback from user
  def save
    # get the feedback, request = get the current request, params gets the current parameters
    p = request.params
    # create the feedback as an object that goes into the database
    f = Feedback.create!(
      path: p['path'],
      category: p['category'],
      body: p['body'],
      visit: current_visit,
    )
    # escape markdown and track in ahoy
    # feedback_submitted is the event (what is happening that we are trakcing) we are tracking
    notify_new_feedback f
    ahoy.track :feedback_submitted, feedback_id: f.id
    render plain: '', status: :no_content
  end
end
