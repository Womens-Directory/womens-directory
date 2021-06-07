class Admin::BaseController < ApplicationController
  before_action :require_user!
end
