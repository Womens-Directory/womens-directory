class Admin::Fresh::LocationsController < ApplicationController
  before_action :require_authorized_user!

  def new
    @title = 'Create New Location'
    @location = Location.new
  end

  def create
    @location = Location.new location_params
    unless @location.save
      flash.alert = "Please fix the following issues: #{@location.errors.full_messages.join(', ')}"
      render :new
      return
    end

    flash.notice = notice_msg @location
    @title = 'Create New Location'
    @location = Location.new
    render :new
  end

  private

  def require_authorized_user!
    require_user!
    authorize! :create, Location
  end

  def location_params
    params.require(:location).permit %i[
      org_id
      name
      website
      desc
      address1
      address2
      city
      state
      zip
      visible
    ]
  end

  def link_to(text, url)
    "<a href='#{url}' target='_blank'>#{text}</a>".html_safe
  end

  def notice_msg(location)
    bits = [
      'Location created successfully.',
      (link_to('View live.', show_location_path(location.id)) if location.visible),
      link_to('View in admin.', Route.admin_show_path_for(@location)),
    ]
    bits.compact.join(' ').html_safe
  end
end
