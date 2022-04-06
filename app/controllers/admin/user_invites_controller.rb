class Admin::UserInvitesController < ApplicationController
  before_action :require_authorized_user!

  def new
  end

  def create
    email = params[:email]
    user = User.create! email: email, roles: [:data_contributor]
    UserMailer.welcome(user).deliver_now
    flash[:notice] = "Invitation sent to #{email}."
    redirect_to request.path
  end

  def require_authorized_user!
    require_user!
    authorize! :invite, User
  end
end
