module Admin::BirdseyeHelper
  def map_tag(locs)
    j = locs.map do |l|
      {
        name: l.name,
        latitude: l.latitude.to_f,
        longitude: l.longitude.to_f,
      }
    end.to_json
    "<div class=\"map-embed-birdseye\" data-locs=\"#{h(j)}\"></div>".html_safe
  end
end
