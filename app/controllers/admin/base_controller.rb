class Admin::BaseController < ApplicationController
  before_action :require_user!
end

# before_action is used to prepare the data necessary before the action executes, so before a controller
#action is called, call the helper method :require_user! in ApplicationController
