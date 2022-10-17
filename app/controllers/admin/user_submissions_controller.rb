class Admin::UserSubmissionsController < ApplicationController
  def index
    @title = 'User Submissions'
    @pagy, @subs = pagy Submission.where(confirmed: true).order(created_at: :desc)
  end

  def reject_form
    # TODO
  end
end
