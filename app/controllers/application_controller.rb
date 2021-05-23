class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers

  helper_method :current_user, :crumbs, :markdown, :top_level_pages

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

  def markdown(text)
    Kramdown::Document.new(text).to_html.html_safe
  end

  def root_page
    Comfy::Cms::Page.where parent_id: nil
  end

  # List all CMS pages that are "top level" - immediate children of the root page, excluding the root page
  def top_level_pages
    Comfy::Cms::Page.where(parent_id: root_page).order :position
  end
end
