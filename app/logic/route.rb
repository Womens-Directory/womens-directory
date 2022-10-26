module Route
  class << self
    def admin_show_path_for(record)
      RailsAdmin::Engine.routes.url_helpers.show_path record.class.name.underscore.to_sym, record.id
    end

    def admin_edit_path_for(record)
      RailsAdmin::Engine.routes.url_helpers.edit_path record.class.name.underscore.to_sym, record.id
    end
  end
end
