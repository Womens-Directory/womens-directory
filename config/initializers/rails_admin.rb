# https://github.com/sferik/rails_admin/issues/887
require "nested_form/engine"
require "nested_form/builder_mixin"

MODELS_WITH_HISTORY = %w[
  Category
  Location
  Org
  PhoneNumber
]

HIDDEN_MODELS = %w[
  PaperTrail::VersionAssociation
  Comfy::Cms::Categorization
  Comfy::Cms::Category
  Comfy::Cms::File
  Comfy::Cms::Fragment
  Comfy::Cms::Layout
  Comfy::Cms::Page
  Comfy::Cms::Revision
  Comfy::Cms::Site
  Comfy::Cms::Snippet
  Comfy::Cms::Translation
]

RailsAdmin.config do |config|
  config.authorize_with do |controller|
    class RailsAdmin::MainController
      include Passwordless::ControllerHelpers
    end

    unless controller.authenticate_by_session(User)
      raise ActionController::RoutingError, 'Not Found'
    end
  end

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  config.current_user_method { authenticate_by_session(User) }

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    history_index { only MODELS_WITH_HISTORY }
    history_show { only MODELS_WITH_HISTORY }
  end

  HIDDEN_MODELS.each do |m|
    config.model m do
      visible false
    end
  end
end
