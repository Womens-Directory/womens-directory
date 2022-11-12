class Admin::FreshController < ApplicationController
  before_action :require_authorized_user!

  def index
    @title = 'Quick Create'
  end

  private

  def require_authorized_user!
    require_user!
    authorize! :create, Location
  end
end
