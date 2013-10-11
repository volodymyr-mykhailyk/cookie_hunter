require 'pry'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'
require 'capybara/rspec'
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



  Capybara.server_port = 31337
  Capybara.default_wait_time = 10
  Capybara.javascript_driver = :chrome

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    DatabaseCleaner.clean_with(:truncation)
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
    config.include FactoryGirl::Syntax::Methods
    config.render_views
    config.include Devise::TestHelpers, type: :controller
  end
end

Spork.each_run do
  DatabaseCleaner.clean_with(:truncation)
  Rails.application.reload_routes!
  FactoryGirl.reload
end


unless Spork.using_spork?
#Capybara use the same connection
  class ActiveRecord::Base
    mattr_accessor :shared_connection
    @@shared_connection = nil

    def self.connection
      @@shared_connection || retrieve_connection
    end
  end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
  ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
end