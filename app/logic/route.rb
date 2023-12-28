module Route
  class << self
    def admin_show_path_for(record)
      return '#' unless record
      RailsAdmin::Engine.routes.url_helpers.show_path record.class.name.underscore.to_sym, record.id
    end

    def admin_edit_path_for(record)
      return '#' unless record
      RailsAdmin::Engine.routes.url_helpers.edit_path record.class.name.underscore.to_sym, record.id
    end

    def show_url_for(record)
      case record.class.name
      when 'Org'
        Rails.application.routes.url_helpers.show_org_url record
      when 'Location'
        Rails.application.routes.url_helpers.show_location_url record
      else
        raise "No route for #{record.class}"
      end
    end
  end
end
