class Admin::UserPermissionsController < ApplicationController
  before_action :require_authorized_user!

  def index
  end

  def update
  end

  def require_authorized_user!
    require_user!
    authorize! :manage, User
  end
end
