Geocoder.configure(
  lookup: :google,
  api_key: ENV['GOOGLE_MAPS_API_KEY'],
  ip_lookup: :geoip2,
  geoip2: { file: Rails.root.join('lib', 'GeoLite2-City.mmdb') },
)
