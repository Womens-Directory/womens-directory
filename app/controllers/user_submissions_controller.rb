class UserSubmissionsController < ApplicationController
  def form
    @loc = Location.new
    @org = Org.new
    @phone = PhoneNumber.new
    @email = Email.new
    @sub = Submission.new
    @org_exist = true
    render_form
  end

  def create
    @org_exist = org_exist?

    @loc = Location.new location_params

    @org = org_from_params
    if !@org
      @org = Org.new
      render_error "Organization cannot be blank. Please select an existing organization or enter details for a new one."
      return
    end
    @org.id = nil unless org_exist?
    @loc.org = @org

    @loc.category_ids = category_ids
    if @loc.category_ids.empty?
      render_error "Please select the categories of services that your location provides."
      return
    end

    @phone = PhoneNumber.new phone_params
    @loc.phone_numbers << @phone if @phone.number.present?

    @email = Email.new email_params
    @loc.emails << @email if @email.address.present?

    @sub = Submission.new submission_params
    @sub.confirmation_token = Random.urlsafe_base64
    @loc.submission = @sub
    @org.submission = @sub if @org.new_record?

    records = [@sub, @org, @loc]
    ApplicationRecord.transaction do
      success = records.all?(&:save)
      unless success
        error_messages = records.map(&:errors).flat_map(&:full_messages)
        render_error error_messages.join(', ')
        return
      end
      UserSubmissionsMailer.confirm(@sub).deliver_now
    end

    @title = "Thank you!"
    @email = @sub.contact_email
  end

  def confirm
    subm = Submission.find_by confirmation_token: params[:token]
    render 'confirm_not_found', status: 404 and return unless subm
    subm.update! confirmed: true
  end

  private

  def render_form
    @title = "Add Org and Location"
    @cats = Category.all.order(:name)
    @orgs = Org.where(visible: true).order(:name)
    render 'form'
  end

  def render_error(msg)
    flash.alert = "Please fix the following issues: #{msg}"
    render_form
  end

  def location_params
    params.require(:location).permit %i[name desc address1 address2 city state zip website]
  end

  def org_params
    params.require(:org).permit %i[id name website desc]
  end

  def phone_params
    params.require(:phone_number).permit %i[number call sms always_open]
  end

  def email_params
    params.require(:email).permit %i[address]
  end

  def submission_params
    params.require(:submission).permit %i[additional_notes contact_email]
  end

  def org_from_params
    return existing_org if org_exist?
    Org.new org_params
  end

  def existing_org
    return nil unless org_exist?
    Org.find_by id: org_params[:id]
  end

  def org_exist?
    params.permit(:org_exist)
    params[:org_exist] == 'true'
  end

  def category_ids
    params.permit!.keys.map { |k| /^category_(\d+)$/.match(k) }.compact.map { |m| m[1].to_i }
  end

  class NoOrgSelectedError < StandardError; end
end
