class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers

  helper_method :current_user, :require_user!, :crumbs, :markdown, :top_level_pages
  before_action :set_paper_trail_whodunnit

  private

  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  def require_user!
    raise ActionController::RoutingError, 'Not Found' unless current_user
  end

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
    Comfy::Cms::Page.where(parent_id: root_page).order :position
  end
end
