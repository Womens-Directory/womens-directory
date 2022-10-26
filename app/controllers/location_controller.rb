class LocationController < ApplicationController
  def show
    @category = Category.visible.find(params[:cat_id]) if params[:cat_id]
    @location = Location.visible.find(params[:id])
    @title = [@location, @category].select {|i| i}.map(&:name).join " – "
    ahoy.track :location_viewed, category_id: @category&.id, location_id: @location.id
  end
end
