class UserSubmissionController < ApplicationController
  def form
    @cats = Category.all.order(:name)
    @orgs = Org.all.order(:name)
  end

  def create
    begin
      save_records
    rescue NoOrgSelectedError
      flash.alert = "No organization selected. Please select your organization from the drop-down list."
      redirect_to submission_form_path
    end
  end

  private

  def save_records
    respond_to do |format|
      format.json do
        render json: {errors: []}, status: :not_found
      end
    end
    # usp = Params.new params
    # loc = usp.location
    # org = loc.org

    # ap loc
    # ap loc.phone_numbers
    # ap loc.emails

    # unless loc.save
    #   flash.alert = "Please fix the following issues with your submission: #{loc.errors.full_messages.join(', ')}"
    #   redirect_to submission_form_path
    # end
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
