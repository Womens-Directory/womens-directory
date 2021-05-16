class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers

  helper_method :current_user, :top_level_pages

  private

  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  def root_page
    Comfy::Cms::Page.where parent_id: nil
  end

  # List all CMS pages that are "top level" - immediate children of the root page, excluding the root page
  def top_level_pages
    Comfy::Cms::Page.where parent_id: root_page
  end
end
