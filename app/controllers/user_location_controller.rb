class UserLocationController < ApplicationController
  def save
    zip = json_body['zip']
    lat = json_body['lat']
    lon = json_body['lon']
    error and return if !(zip || (lat && lon))

    if !(lat && lon)
      latlon = geocode zip
      error and return unless latlon
      lat, lon = latlon
    end

    session[:lat] = lat
    session[:lon] = lon
    sort_by_distance
  end

  def clear
    session.delete :lat
    session.delete :lon
    sort_by_name
  end

  def sort_by_name
    session[:sort_by] = :name
    redirect_back fallback_location: Rails.root
  end

  def sort_by_distance
    redirect_to :request_user_location and return unless user_coords

    session[:sort_by] = :distance
    redirect_back fallback_location: Rails.root
  end

  private

  def json_body
    @json_body ||= JSON.parse request.raw_post
  end

  def geocode(zip)
    Rails.cache.fetch "coords/zip/#{zip}" do
      return unless result = Geocoder.search(zip)[0]
      loc = result.data['geometry']['location']
      return loc['lat'], loc['lng']
    end
  end

  def error
    flash.alert = 'Sorry, there was a problem saving your location. Please try again.'
    head :bad_request
  end
end
