require 'pry'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'
require 'capybara/rspec'
require 'capybara/mechanize'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end


Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  require 'rails/application'
  Spork.trap_method(Rails::Application, :eager_load!)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rails'
  require 'sidekiq/testing'

  Capybara.current_driver = :mechanize
  Capybara.app_host = 'http://localhost:3001'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  RSpec.configure do |config|
    config.use_transactional_fixtures = false
    config.infer_base_class_for_anonymous_controllers = false
    config.include FactoryGirl::Syntax::Methods
    config.render_views
    config.include Devise::TestHelpers, type: :controller

    #cleaning
    DatabaseCleaner.strategy = :truncation
    config.before(:each) { DatabaseCleaner.start }
    config.after(:each) { DatabaseCleaner.clean }
  end
end

Spork.each_run do
  DatabaseCleaner.clean_with(:truncation)
  Rails.application.reload_routes!
  FactoryGirl.reload
end


