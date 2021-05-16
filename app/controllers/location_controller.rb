class LocationController < ApplicationController
  def show
    @category = Category.find(params[:cat_id]) if params[:cat_id]
    @location = Location.find(params[:id])
  end
end
