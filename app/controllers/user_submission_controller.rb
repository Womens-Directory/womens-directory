class UserSubmissionController < ApplicationController
  def form
    @cats = Category.all.order(:name)
    @org_exists = true
    @orgs = Org.all.order(:name)

    @loc = Location.new
    @org = Org.new
    @sub = Submission.new
    # TODO: phone, email
  end

  def create
    @cats = Category.all.order(:name)
    @orgs = Org.all.order(:name)

    @loc = Location.new location_params
    @org = existing_org || Org.new(org_params)
    @org.id = nil unless org_exists?
    @loc.org = @org
    @sub = Submission.new submission_params

    @org_exists = org_exists?

    @loc.org = @org
    # TODO: phone, email
    ap @loc
    ap @org
    ap @loc.org
    # @loc.submission = @sub
    # TODO: fix sub association

    unless @loc.save
      flash.alert = "Please fix the following issues: #{@loc.errors.full_messages.join(', ')}"
      @cats = Category.all.order(:name)
      @orgs = Org.all.order(:name)
      render 'form'
    end
  end

  private

  def location_params
    params.require(:location).permit %i[name desc address1 address2 city state zip website]
  end

  def org_params
    params.require(:org).permit %i[id name website desc]
  end

  def submission_params
    params.require(:submission).permit %i[additional_notes contact_email]
  end

  def existing_org
    return nil unless org_exists?
    Org.find org_params[:id]
  end

  def org_exists?
    params.permit(:org_exists)
    params[:org_exists] == 'true'
  end

  class Params
    def initialize(raw)
      @raw = raw
    end

    def location
      Location.new(
        name: @raw[:loc_name],
        desc: @raw[:loc_desc],
        address1: @raw[:loc_address1],
        address2: @raw[:loc_address2],
        city: @raw[:loc_city],
        state: @raw[:loc_state],
        zip: @raw[:loc_zip],
        website: @raw[:loc_website],
        emails: emails,
        phone_numbers: phone_numbers,
        categories: categories,
        org: org,
      )
    end

    def emails
      return nil unless @raw[:loc_email] != ''
      [Email.new(address: @raw[:loc_email])]
    end

    def phone_numbers
      return nil unless @raw[:loc_phone] != ''
      [PhoneNumber.new(
        number: @raw[:loc_phone],
        call: @raw.has_key?(:loc_phone_can_call),
        sms: @raw.has_key?(:loc_phone_can_text),
        always_open: @raw.has_key?(:loc_phone_247),
      )]
    end

    def categories
      ids = @raw.keys.map { |k| k.match(/^loc_cat_(\d+)$/) }.compact.map { |m| m[1].to_i }
      Category.where(id: ids)
    end

    def org
      if @raw[:org_exists] == 'true'
        existing_org
      elsif @raw[:org_exists] == 'false'
        new_org
      else
        throw 'org_exists must be true or false'
      end
    end

    def existing_org
      raise NoOrgSelectedError.new unless oid = @raw[:org_id]
      Org.find(@raw[:org_id])
    end

    def new_org
      Org.new(
        name: @raw[:org_name],
        website: @raw[:org_website],
        desc: @raw[:org_desc],
      )
    end
  end

  class NoOrgSelectedError < StandardError; end
end
