source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
# Fix segmentation fault on assets:precompile - https://github.com/sass/sassc-ruby/issues/207
gem 'sprockets', '< 4'

#First-party analytics for RailsTrack visits and events in Ruby, JavaScript, and native apps
# https://github.com/ankane/ahoy
gem 'ahoy_matey', '~> 3.2'
# Annotates Rails/ActiveRecord Models, routes, fixtures, and others based on the database schema, in other words, adds comments that summarize the current schema at top of files such as model file
# https://github.com/ctran/annotate_models/
gem 'annotate', '~> 3.1'
# Ruby debugging companion: pretty print Ruby objects to visualize their structure in color and with proper indentation. Prints out arrays and hashes easier to read, with indexes etc.
# https://github.com/awesome-print/awesome_print/
gem 'awesome_print', '~> 1.9'
# Official AWS Ruby gem for Amazon Simple Storage Service (Amazon S3). This gem is part of the AWS SDK for Ruby (The SDK helps take the complexity out of coding by providing Ruby classes for many AWS services)
# https://github.com/aws/aws-sdk-ruby/
gem 'aws-sdk-s3', '~> 1.96', require: false
# ComfortableMexicanSofa is a powerful Ruby on Rails 5.2+ CMS (Content Management System) Engine
# https://github.com/comfy/comfortable-mexican-sofa
gem 'comfortable_mexican_sofa', '~> 2.0'
#Draper adds an object-oriented layer of presentation logic to your Rails apps. Decorators/View-Models for Rails Applications. Adds extra file of logic that doesn't make sense in contorller or model and/or instead of helper methods to add to code for view
# https://github.com/drapergem/draper/
gem 'draper', '~> 4.0'
# Faker, a port of Data::Faker from Perl, is used to easily generate fake data: names, addresses, phone numbers, etc. for seed data so you can have real looking test data and your database populated with more than a few reocrds
# https://github.com/faker-ruby/faker/
gem 'faker', '~> 2.17'
# font-awesome-rails provides the Font-Awesome web fonts and stylesheets as a Rails engine for use with the asset pipeline.( The asset pipeline provides a framework to concatenate and minify or compress JavaScript and CSS assets.)
# https://github.com/bokmann/font-awesome-rails/
gem 'font-awesome-rails', '~> 4.7'
# Object geocoding (by street or IP address), reverse geocoding (coordinates to street address), distance queries for ActiveRecord and Mongoid, result caching (A result cache is an area of memory, either in the Shared Global Area (SGA) or client application memory, that stores the results of a database query or query block for reuse. The cached rows are shared across SQL statements and sessions unless they become stale.)
# https://github.com/alexreisner/geocoder/
gem 'geocoder', '~> 1.6'
# 
gem 'kramdown', '~> 2.3'
gem 'maxminddb', '~> 0.1.22'
# pagy returns from the server a certain amount of pages from the requested page, instead of iterating through everything in the database, it saves processing time/effort, loading data time is constant
# https://github.com/ddnexus/pagy
gem 'pagy', '~> 4.8'
# https://ddnexus.github.io/pagy/#gsc.tab=0
gem 'paper_trail-association_tracking', '~> 2.1'
gem 'paper_trail', '~> 11.1'
# passwordless authentication: https://github.com/mikker/passwordless/
gem 'passwordless', '~> 0.10.0'
gem 'pg', '~> 1.2'
gem 'pg_search', '~> 2.3'
gem 'rails_admin', '~> 2.0'
gem 'rest-client', '~> 2.1'
gem 'rexml', '~> 3.2'
gem 'rspec-rails', '~> 5.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails', '~> 0.3.9'
end

group :development do
  gem 'letter_opener', '~> 1.7'
  gem 'listen', '~> 3.3'
  gem 'memory_profiler'
  gem 'niceql', '~> 0.1.25'
  gem 'rack-mini-profiler'
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
