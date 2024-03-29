source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '3.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1', '>= 6.1.6'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 5.6'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
# Fix segmentation fault on assets:precompile - https://github.com/sass/sassc-ruby/issues/207
gem 'sprockets', '< 4'

gem 'ahoy_matey', '~> 3.2'
gem 'annotate', '~> 3.1'
gem 'awesome_print', '~> 1.9'
gem 'aws-sdk-s3', '~> 1.96', require: false
gem 'cancancan', '~> 3.3'
gem 'comfortable_mexican_sofa', '~> 2.0'
gem 'draper', '~> 4.0'
gem 'faker', '~> 2.17'
gem 'flipper', '~> 0.25.2'
gem 'flipper-active_record', '~> 0.25.2'
gem 'flipper-ui', '~> 0.25.2'
gem 'font-awesome-rails', '~> 4.7'
gem 'geocoder', '~> 1.6'
gem 'kramdown', '~> 2.3'
gem 'matrix', '~> 0.4.2'
gem 'maxminddb', '~> 0.1.22'
gem 'net-smtp', '~> 0.4.0'
gem 'nokogiri', '>= 1.13.4', '< 2'
gem 'pagy', '~> 4.8'
gem 'paper_trail-association_tracking', '~> 2.1'
gem 'paper_trail', '~> 11.1'
gem 'passwordless', '~> 0.11.0'
gem 'pg', '~> 1.2'
gem 'pg_search', '~> 2.3'
gem 'rails_admin', '~> 2.0'
gem 'rest-client', '~> 2.1'
gem 'rexml', '~> 3.2'
gem 'role_model', '~> 0.8'
gem 'sentry-ruby', '~> 5.6'
gem 'sentry-rails', '~> 5.6'
gem 'shakapacker', '~> 6.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails', '< 6.3' # https://github.com/thoughtbot/factory_bot_rails/issues/431
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-rails', '~> 5.0'
end

group :development do
  gem 'letter_opener', '~> 1.7'
  gem 'listen', '~> 3.3'
  gem 'memory_profiler'
  gem 'niceql', '~> 0.1.25'
  gem 'rack-mini-profiler'
  gem 'ruby-lsp', require: false
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'stackprof'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end
