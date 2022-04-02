class CategoryController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @locations = @category.locations.order :name
    # params[:id] is the id number in the url

    # calculate users coordinates and find distance btwn them and the category's locations
    # if the session :sort_by(name or distance) attribute is equal to distance and user_coords are present
    # truthy = if if statement thinks something is true, falsey = is if an if statement thinks it's false
    # false is not the same as nil, nil = falsey, false is falsey
    # what the user set the wd to sort their location by
    # method: is the users session set to sort by distance and their user coordinates are present, then
    # method: iterate through all location, and calculate the distance between between their coords and
    # locations lat and long
    if session[:sort_by] == 'distance' && user_coords
      @locations.each do |loc|
        loc.distance = Geocoder::Calculations.distance_between user_coords, [loc.latitude, loc.longitude]
      end
      # sort by distance
      @locations = @locations.sort_by &:distance
      @show_distance = true
    end
    # how do you use session? how does it work

    # track the category the person is viewing using ahoy with its name and id
    @title = @category.name
    ahoy.track :category_viewed, category_id: @category.id
  end
end
