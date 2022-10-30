def setup_flipper
  return if in_rake?

  # Register all known features
  Features::FEATURES.keys.each { |f| Flipper.add f }

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

begin
  setup_flipper
rescue StandardError => e
  Rails.logger.error "Failed to setup Flipper: #{e}"
end
