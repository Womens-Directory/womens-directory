class UserLocationController < ApplicationController
  ERR_MSG = 'Sorry, there was a problem saving your location. Please try again.'

  def save
    zip = json_body['zip']
    lat = json_body['lat']
    lon = json_body['lon']
    flash.alert = ERR_MSG and return if !(zip || (lat && lon))

    if !(lat && lon)
      lat, lon = geocode zip
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
    result = Geocoder.search(zip)[0]
    flash.alert = ERR_MSG and return unless result

    loc = result.data['geometry']['location']
    return loc['lat'], loc['lng']
  end
end
