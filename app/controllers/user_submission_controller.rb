class UserSubmissionController < ApplicationController
  def form
    @loc = Location.new
    @org = Org.new
    @sub = Submission.new
    @phone = PhoneNumber.new
    @email = Email.new
    @org_exists = false
    render_form
  end

  def create
    @org_exists = org_exists?

    @loc = Location.new location_params
    @org = org_from_params
    if !@org
      @org = Org.new
      render_error "Organization cannot be blank. Please select an existing organization or enter details for a new one."
      return
    end
    @org.id = nil unless org_exists?
    @loc.org = @org
    @sub = Submission.new submission_params
    # TODO: phone, email


    @loc.org = @org
    # TODO: location categories
    @sub.owner = @loc

    success = false
    ApplicationRecord.transaction do
      success = @org.save && @loc.save && @sub.save
    end

    unless success
      error_messages = [@org, @loc, @sub].map(&:errors).flat_map(&:full_messages)
      render_error error_messages.join(', ')
      return
    end
  end

  private

  def render_form
    @cats = Category.all.order(:name)
    @orgs = Org.all.order(:name)
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

  def submission_params
    params.require(:submission).permit %i[additional_notes contact_email]
  end

  def org_from_params
    return existing_org if org_exists?
    Org.new org_params
  end

  def existing_org
    return nil unless org_exists?
    Org.find_by id: org_params[:id]
  end

  def org_exists?
    params.permit(:org_exists)
    params[:org_exists] == 'true'
  end

  class NoOrgSelectedError < StandardError; end
end
