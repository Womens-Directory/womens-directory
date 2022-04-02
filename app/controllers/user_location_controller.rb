class UserLocationController < ApplicationController
  # ask users browsers where they are, (look up GeoLocation on MDN)

  # json_body is what is posted by the browser to this end point (somewhere you call
# to get data from or to, could be anything such as route or controller)
  def save
    zip = json_body['zip']
    lat = json_body['lat']
    lon = json_body['lon']
    # you need a zip or a lat and long, if not throw an error and exit early
    # and is a low precedence operator
    error and return if !(zip || (lat && lon))

    # same as above, if those don't exist, throw an error and return (=stop the function)
    # if !(zip || (lat && lon))
    #   error
    #   return
    # end

    if !(lat && lon)
      # turn the zip code into a lat long using geocode
      latlon = geocode zip
      # stop the function unless there is a latlong, if there isn't latlong throw an error
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

  #
  def sort_by_distance
    # unless there are user_coords ('if there aren't user_coords, stop the function with return), otherwise
    # redirect to this route
    redirect_to :request_user_location and return unless user_coords
    # session is a hash stored in the database that is coupled with a users cookies, set the session :sort_by
    # attribute to :distance (:distance is a symbol, is more memory efficient than string sometimes)
    session[:sort_by] = :distance
    # if you can't redirect back somewhere go to the homepage
    # redirect_back is the method, fallback_location: Rails.root are the two arguments in a key/value pair
    redirect_back fallback_location: Rails.root
  end

  private

  # a memoizing method for json meaning use the previous value generated otherwise generate it
  # it saves time and doesn't duplicate work parsing json everytime it is called
  def json_body
    @json_body ||= JSON.parse request.raw_post
  end


  def geocode(zip)
    # cache says I want you to calc a value for me and if it's not present, fetch the value from the cache or
    # generate it from the block given
    Rails.cache.fetch "coords/zip/#{zip}" do
      # get a result from the geocoder, if it's not there return
      return unless result = Geocoder.search(zip)[0]
      loc = result.data['geometry']['location']
      return loc['lat'], loc['lng']
    end
  end

  #
  def error
    # flash is a way to show something on screen of next page user visits
    # alert with the following method
    flash.alert = 'Sorry, there was a problem saving your location. Please try again.'
    # sets the status code for the response ( see HTTP )
    head :bad_request
  end
end
