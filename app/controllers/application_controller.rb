class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers

  helper_method :current_user, :crumbs

  private

  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  def crumbs(category, location)
    home = helpers.link_to 'Home', '/'
    cat = helpers.link_to(category.name, show_category_path(category)) if category
    loc = helpers.link_to(location.name, show_category_location_path(category, location)) if category && location
    [home, cat, loc].reject(&:blank?).join(' &raquo; ').html_safe
  end
end
