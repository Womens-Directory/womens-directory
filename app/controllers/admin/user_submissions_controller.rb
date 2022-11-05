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
    @title = 'Reject Submission'
    render_invalid_class_error and return unless set_target
  end

  def reject
    render_invalid_class_error and return unless set_target
    # TODO: this is a circular error in rendering this page, must fix.

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
    return false unless klass
    @target = klass.find(id)
    return true
  end

  def render_invalid_class_error
    render_error "Invalid class: #{params[:class]}, expected one of: #{VALID_CLASS_TARGETS.keys.join(', ')}"
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
