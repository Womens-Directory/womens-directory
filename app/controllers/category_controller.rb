class CategoryController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @locations = @category.locations.order :name

    if session[:sort_by] == 'distance' && user_coords
      @locations.each do |loc|
        loc.distance = Geocoder::Calculations.distance_between user_coords, [loc.latitude, loc.longitude]
      end
      @locations = @locations.sort_by &:distance
      @show_distance = true
    end

    @title = @category.name
    ahoy.track :category_viewed, category_id: @category.id
  end
end
