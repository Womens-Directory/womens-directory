class LocationController < ApplicationController
  def show
    @category = Category.visible.find(params[:cat_id]) if params[:cat_id]
    @location = Location.visible.find(params[:id])
    @prompt = PromptExternalLink.first if new_visitor?
    @title = [@location, @category].select {|i| i}.map(&:name).join " – "

    ahoy.track :location_viewed, category_id: @category&.id, location_id: @location.id
  end

  def new_visitor?
    visit_ids = Ahoy::Visit.where(visitor_token: self.cookies["ahoy_visitor"]).pluck(:id)
    # Visits are inserted and retrieved in canonical order of id. Only check the timestamp on the latest visit.
    Ahoy::Event.where({name: "location_viewed", visit_id: visit_ids.last}).count == 0
  end
end

