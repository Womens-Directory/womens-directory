require_relative "boot"

require "rails/all"
require "./lib/middleware/bot_detector"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WomensDirectory
  class Application < Rails::Application
    # Ensuring that ActiveStorage routes are loaded before Comfy's globbing
    # route. Without this file serving routes are inaccessible.
    config.railties_order = [ActiveStorage::Engine, :main_app, :all]
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.generators do |g|
      g.template_engine :erb
    end

    config.middleware.use BotDetector
  end
end
