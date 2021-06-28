class UserLocationController < ApplicationController
  def save
    zip = params[:zip]
    lat = params[:lat]
    lon = params[:lon]
    if not zip || (lat && lon)
      render plain: 'Must have either zip or lat and lon', status: 400
      return
    end

    if zip
      result = Geocoder.search(zip)[0]
      if not result
        render plain: "No geocoding results for #{zip}", status: 400
        return
      end
      loc = result.data['geometry']['location']
      lat = loc['lat']
      lon = loc['lng']
    end

    session['lat'] = lat
    session['lon'] = lon

    flash.notice = 'Location saved.'
    redirect_back fallback_location: :root
  end
end
