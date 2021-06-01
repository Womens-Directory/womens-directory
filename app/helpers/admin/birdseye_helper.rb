module Admin::BirdseyeHelper
  def map_tag(locs)
    j = locs.map do |l|
      {
        name: l.full_address_with_name,
        latitude: l.latitude.to_f,
        longitude: l.longitude.to_f,
      }
    end.to_json
    "<div class=\"map-embed-birdseye\" data-locs=\"#{h(j)}\"></div>".html_safe
  end

  def checks(loc)
    conds = %i[
      must_have_addr_or_pn
      addrs_must_have_neighs
    ]
    errors = conds.flat_map { |cond| send(cond, loc) }.select { |x| x }
    lis = errors.map { |msg| "<li>❌ #{msg}</li>" }.join('')
    "<ul>#{lis}</ul>".html_safe
  end

  def must_have_addr_or_pn(loc)
    return "No address and no phone numbers!" if loc.phone_numbers.empty? && !loc.address1?
  end

  def addrs_must_have_neighs(loc)
    has_addr = loc.address1?
    missing_neigh = loc.neighborhood.nil? || loc.neighborhood.empty?
    return "Has address but no neighborhood!" if has_addr && missing_neigh
  end
end
