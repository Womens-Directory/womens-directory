class Admin::BaseController < ApplicationController
  before_action :require_user!
end

# Admin::BaseController is the controller used by Rails Admin (what we use to manipulate the database)

# before_action is used to prepare the data necessary before the action executes, so before a controller
#action is called, call the helper method :require_user! in ApplicationController
# require_user!  raises an error if there isn't a current_user
