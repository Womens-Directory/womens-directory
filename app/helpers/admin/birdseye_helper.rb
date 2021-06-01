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

  def checks(loc)
    conds = %i[
      has_addr
      has_pn
      has_neigh
    ]
    evals = conds.map { |cond| send(cond, loc) }
    lis = evals.map { |msg, sym| "<li>#{sym} #{msg}</li>" }.join('')
    puts lis
    "<ul>#{lis}</ul>".html_safe
  end

  def x_grey
    "✖️"
  end

  def x_red
    "❌"
  end

  def check_grey
    "✔️"
  end

  def check_green
    "✅"
  end

  def has_addr(loc)
    if loc.phone_numbers.empty? && !loc.address1?
      return ["No address and no phone numbers!", x_red]
    end
    loc.address1? ? ['Has address', check_grey] : ['No address', x_grey]
  end

  def has_pn(loc)
    [pluralize(loc.phone_numbers.count, "phone numbers"), loc.phone_numbers.any? ? "📱" : x_grey]
  end

  def has_neigh(loc)
    if loc.neighborhood.nil? || loc.neighborhood.empty?
      return ["No neighborhood specified!", x_red]
    end
    ["Neighborhood: #{loc.neighborhood}", check_grey]
  end
end
