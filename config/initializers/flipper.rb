def setup_flipper
  if in_rake?
    Rails.logger.info "Refusing to setup Flipper in a Rake task"
    return
  end

  Flipper::UI.configure do |config|
    config.descriptions_source = ->(keys) do
      Features::FEATURES.transform_keys(&:to_s)
    end
    config.show_feature_description_in_list = true
  end

  # Register all known features
  Features::FEATURES.keys.each { |f| Flipper.add f }
end

def in_rake?
  !!$RAKE_TASK
end

begin
  Rails.application.reloader.to_prepare { setup_flipper }
rescue StandardError => e
  Rails.logger.error "Failed to setup Flipper: #{e}"
end
