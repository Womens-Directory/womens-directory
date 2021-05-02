# https://github.com/sferik/rails_admin/issues/887
require "nested_form/engine"
require "nested_form/builder_mixin"

RailsAdmin.config do |config|
  unless Rails.env.development? || Rails.env.test?
    admin_password = ENV['ADMIN_PASSWORD']
    raise "ADMIN_PASSWORD is unset" unless admin_password

    config.authenticate_with do
      authenticate_or_request_with_http_basic('Login required') do |username, password|
        if username != 'wd' || password != admin_password
          raise "Unauthorized login to Rails Admin: #{username}/#{password}"
        end
        true
      end
    end
  end

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

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

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
