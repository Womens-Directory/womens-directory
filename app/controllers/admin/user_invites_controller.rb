class Admin::UserInvitesController < ApplicationController
  before_action :require_authorized_user!

  def new
  end

  def create
  end

  def require_authorized_user!
    require_user!
    authorize! :invite, User
  end
end
