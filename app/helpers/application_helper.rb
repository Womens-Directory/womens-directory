module ApplicationHelper
  include Pagy::Frontend

  def title
    return "Women's Directory" unless @title
    "#{@title} – Women's Directory"
  end

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

  def admin_edit_button(inst)
    return unless current_user

    kind = inst.class.name
    m = kind.match /(.+)Decorator$/ # trim Decorator from tail end of class name if present
    kind = m[1] if m

    text = "Edit this #{kind.titlecase.downcase}"
    attrs = {
      href: RailsAdmin::Engine.routes.url_helpers.edit_path(kind.underscore.to_sym, inst.id),
      class: "button is-danger",
      style: "float: right;",
    }
    attrs_str = attrs.map { |k, v| "#{k}=\"#{v}\"" }.join(' ')
    "<a #{attrs_str}>#{text}</a>".html_safe
  end
end
