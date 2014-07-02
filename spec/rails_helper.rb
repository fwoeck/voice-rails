ENV['RAILS_ENV'] = 'test'

require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)

require 'timecop'
require 'rspec/rails'
require 'capybara/rspec'
require 'database_cleaner'

require './spec/common_helper'
include CommonHelper

Thread.abort_on_exception = true
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!


RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.mock_with :rspec

  config.include Devise::TestHelpers, type: :controller
  config.include FactoryGirl::Syntax::Methods

  config.before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  config.after(:each) do
    Timecop.return
  end

  config.before(:each, js: true) do
    Timecop.return
  end

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

  config.after(:suite) do
  end

  unless ENV['JSCRIPT'].blank?
    require 'puma'
    require 'capybara-screenshot'
    require 'capybara-screenshot/rspec'

    if ENV['SELENIUM'].blank?
      configure_poltergeist_driver
    else
      configure_selenium_driver
    end

    Capybara.default_selector = :css
    Capybara.server_port      = 18080
    Capybara.server do |app, port|
      server = Puma::Server.new(app).tap do |s|
        s.add_tcp_listener '0.0.0.0', 18080
        s.min_threads = 2
        s.max_threads = 8
      end.run

      server.join
    end
  end
end
