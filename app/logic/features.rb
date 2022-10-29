class Features
  FEATURES = {
    user_submissions: 'Users can submit their own locations and organizations for approval.',
  }

  FEATURES.each do |feature, description|
    define_singleton_method "#{feature}?" do
      return Flipper.enabled? feature
    end
  end

  class AuthorizedAdmin
    def current_user(request)
      session = Passwordless::Session.find_by id: request.session['passwordless_session_id--user']
      return nil unless session
      klass = session.authenticatable_type.constantize
      klass.find_by id: session.authenticatable_id
    end

    def matches?(request)
      Ability.new(current_user(request)).can? :manage, :features
    end
  end
end
