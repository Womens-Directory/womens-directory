class FeedbackController < ApplicationController
  def save
    pp request
    render plain: '', status: :no_content
  end
end
