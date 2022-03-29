class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers
  include Pagy::Backend

  helper_method :current_user, :require_user!, :crumbs, :markdown, :top_level_pages, :user_coords
  before_action :set_paper_trail_whodunnit

  private
  # if current_user is nil then assign current_user to the User currently in session?
  # a ||= b means assign b to a if a is null or undefined or false
  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  # raise the RouthingError, Not Found unless there is a valid current_user?
  def require_user!
    raise ActionController::RoutingError, 'Not Found' unless current_user
  end

  # put in bits array the category and location names and paths and pass to arrow_pipeline method
  def crumbs(category, location)
    home = helpers.link_to 'Home', '/'
    bits = [home]

    if category
      bits << helpers.link_to(category.name, show_category_path(category))
      if location
        bits << helpers.link_to(location.name, show_category_location_path(category, location))
      end
    elsif location
      bits << helpers.link_to(location.name, show_location_path(location))
    end

    arrow_pipeline bits
  end

  # take out blank objects in array, join objects in array with the arguement?
  # reject Returns a new Array whose elements are all those from self for which the block
  #returns false or nil:
  # what does .html_safe do? what does escaping mean? 
  def arrow_pipeline(bits)
    bits.reject(&:blank?).join(' &raquo; ').html_safe
  end

  def markdown(text)
    body = Kramdown::Document.new(text).to_html
    "<div class=\"autostyle\">#{body}</div>".html_safe
  end

  def root_page
    Comfy::Cms::Page.where parent_id: nil
  end

  # List all CMS pages that are "top level" - immediate children of the root page, excluding the root page
  def top_level_pages
    Comfy::Cms::Page.published.where(parent_id: root_page).order :position
  end

  def user_coords
    lat = session[:lat]
    lon = session[:lon]
    return nil unless lat && lon
    return [lat, lon]
  end
end

# what are ApplicationController < ActionController::Base, when do you use them and know what kind of methods to put in them
# how does ApplicationController differ from other controllers (controller classes inherit from ApplicationController) The ApplicationController contains code that can be run in all your controllers and it inherits from Rails ActionController::Base class.
# Where is the
