class LocationController < ApplicationController
  def show
    @category = Category.find(params[:cat_id]) if params[:cat_id]
    @location = Location.find(params[:id]) # TODO: only visible
    @title = [@location, @category].select {|i| i}.map(&:name).join " – " # TODO: fix invisible character
    ahoy.track :location_viewed, category_id: @category&.id, location_id: @location.id
  end
end
