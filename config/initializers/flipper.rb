def setup_flipper
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

setup_flipper unless ENV['RAKE']
