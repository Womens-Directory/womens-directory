class Admin::UserPermissionsController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :require_authorized_user!

  def index
    @roles = User.valid_roles
    @users = User.all.order(:email)
  end

  def update
    begin
      count = UserPermissions.set_all! current_user, params
      flash[:notice] = "Successfully updated permissions for #{pluralize count, 'users'}"
    rescue => e
      puts e
      flash[:alert] = "Error setting user permissions: #{e}"
    end
    redirect_to request.path
  end

  def require_authorized_user!
    require_user!
    authorize! :manage, :user_permissions
  end
end
