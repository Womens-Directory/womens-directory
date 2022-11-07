class Admin::UserSubmissionsController < ApplicationController
  before_action :require_authorized_user!

  VALID_NOTIFY_METHODS = %w[none no_reason with_reason]
  # Prevent admins with "manage submissions" permission from hacking us by calling other Rails classes
  VALID_CLASS_TARGETS = {
    'Location' => Location,
    'Org' => Org,
  }

  def index
    @title = 'User Submissions'
    confirmed = Submission.where(confirmed: true)
    @sub_count = confirmed.count
    @pagy, @subs = pagy confirmed.order(created_at: :asc), items: 3
  end

  def reject_form
    set_submission
    @title = 'Reject Submission'
  end

  def reject
    set_submission

    method = params[:notify_method]
    reason = params[:notify_reason]&.strip

    unless method
      render_error 'You must select a notification method'
      return
    end

    unless VALID_NOTIFY_METHODS.include? method
      render_error "Unsupported notification method: #{method}, expected one of: #{VALID_NOTIFY_METHODS.join(', ')}"
      return
    end

    if method == 'with_reason' && reason.empty?
      render_error 'When sending an email with a reason, the reason cannot be blank'
      return
    end

    notify = method != 'none'
    @submission.reject! notify, reason
    flash.notice = 'Successfully rejected submission.'
    redirect_to admin_user_submissions_path
  end

  private

  def set_submission
    @submission = Submission.find params[:id]
  end

  def render_error(msg)
    flash.alert = "Please fix the following issue: #{msg}"
    render 'reject_form'
  end

  def require_authorized_user!
    require_user!
    authorize! :manage, :user_submissions
  end
end
