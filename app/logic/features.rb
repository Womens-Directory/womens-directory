class Features
  FEATURES = {
    user_submissions: 'Users can submit their own locations and organizations for approval.',
  }

  FEATURES.each do |feature, description|
    define_singleton_method "#{feature}?" do
      return Flipper.enabled? feature
    end
  end
end
