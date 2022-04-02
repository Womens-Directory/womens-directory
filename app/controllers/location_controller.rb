class LocationController < ApplicationController
  def show
    @category = Category.find(params[:cat_id]) if params[:cat_id]
    # if params[:cat_id] if you want to view a location without going through category
    @location = Location.find(params[:id])
    # select the cat and location objects meaning only select truthy objects (meaning not nil, going
    # to a location without going to category), map the truthy objects by name and join into a string
    @title = [@location, @category].select {|i| i}.map(&:name).join " – "
    # category_id: @category&.id is a key value argument, & = (safe navigation operator, is used to see
  # if the object is nil or not, if it's nil return nil, if not go ahead with operation)
    ahoy.track :location_viewed, category_id: @category&.id, location_id: @location.id
  end
end
