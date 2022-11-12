class Admin::Fresh::LocationsController < ApplicationController
  def new
    @title = 'Create New Location'
    @location = Location.new
  end

  def create
    render plain: 'not implemented', status: :not_implemented
  end
end
