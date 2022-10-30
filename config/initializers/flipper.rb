def setup_flipper
  return if in_rake?

  if ActiveRecord::Base.connection.migration_context.needs_migration?
    puts 'Cannot initialize Flipper features. Please run migrations.'
  end

  # Ensure all features are registered in the UI
  Features::FEATURES.each do |feature, _|
    Flipper.add feature
  end

  Flipper::UI.configure do |config|
    config.descriptions_source = ->(keys) do
      Features::FEATURES.transform_keys(&:to_s)
    end
    config.show_feature_description_in_list = true
  end
end

def in_rake?
  !ENV['RAKE']
end

def needs_migration?
  ActiveRecord::Base.connection.migration_context.needs_migration?
end
