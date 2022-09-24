class UserSubmissionController < ApplicationController
  def form
    @cats = Category.all.order(:name)
    @orgs = Org.all.order(:name)
  end

  def create
    usp = Params.new params
    @out = usp.category_ids


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
      return [] unless @raw[:loc_email]
      [Email.new(address: @raw[:loc_email])]
    end

    def phone_numbers
      return [] unless @raw[:loc_phone]
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
        Org.find(@raw[:org_id])
      elsif @raw[:org_exists] == 'false'
        Org.new(
          name: @raw[:org_name],
          website: @raw[:org_website],
          desc: @raw[:org_desc],
        )
      else
        throw 'org_exists must be true or false'
      end
    end
  end
end
