class Admin::UserPermissionsController < ApplicationController
  before_action :require_authorized_user!

  def index
    @roles = User.valid_roles
    @users = User.all.order(:email)
  end

  def update
  end

  def require_authorized_user!
    require_user!
    authorize! :manage, User
  end
end
