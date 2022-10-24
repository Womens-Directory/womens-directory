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
    @pagy, @subs = pagy Submission.where(confirmed: true).order(created_at: :desc)
  end

  def reject_form
    @title = 'Reject Submission'
    set_target
  end

  def reject
    set_target

    method = params[:notify_method]
    reason = params[:notify_reason]&.strip
    render_error 'You must select a notification method' and return unless method
    render_error "Unsupported notification method: #{method}" and return unless VALID_NOTIFY_METHODS.include? method
    render_error 'When sending an email with a reason, the reason cannot be blank' and return if method == 'with_reason' && reason.empty?

    ApplicationRecord.transaction do
      @target.destroy!
      @target.submission.destroy!
      notify_with method, reason
    end

    flash.notice = 'Successfully rejected submission and deleted record.'
    redirect_to admin_user_submissions_path
  end

  private

  def set_target
    id = params[:id]
    klass = VALID_CLASS_TARGETS[params[:class]]
    render_error "Invalid class: #{params[:class]}, expected one of: #{VALID_CLASS_TARGETS.keys.join(', ')}" and return unless klass
    @target = klass.find(id)
  end

  def render_error(msg)
    flash.alert = "Please fix the following issue: #{msg}"
    render 'reject_form'
  end

  def notify_with(method, reason)
    return if method == 'none'
    UserSubmissionsMailer.reject(@target.submission, @target, reason).deliver_now
  end

  def require_authorized_user!
    require_user!
    authorize! :manage, :user_submissions
  end
end
