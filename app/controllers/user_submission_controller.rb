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

    def category_ids
      @raw.keys.map { |k| k.match(/^loc_cat_(\d+)$/) }.compact.map { |m| m[1].to_i }
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

    def location
      Location.new(
        name: @raw[:loc_name],
        desc: @raw[:loc_desc],
        # TODO: address1, address2, city, state, zip
        website: @raw[:loc_website],
        emails: emails,
        phone_numbers: phone_numbers,
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
  end
end
