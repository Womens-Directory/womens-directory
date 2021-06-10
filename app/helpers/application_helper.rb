module ApplicationHelper
  include Pagy::Frontend

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
