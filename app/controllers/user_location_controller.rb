class UserLocationController < ApplicationController
  ERR_MSG = 'Sorry, there was a problem saving your location. Please try again.'

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

    session['lat'] = lat
    session['lon'] = lon
    flash.notice = 'Your location has been saved on your device.'
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
    flash.alert = ERR_MSG
    head :bad_request
  end
end
