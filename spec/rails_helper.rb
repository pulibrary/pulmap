# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/poltergeist'
require 'capybara/rspec'
require 'capybara/rails'
require 'devise'
require 'factory_girl'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout: 60)
end
Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 10

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join("spec", "support", "**", "*.rb")].sort.each { |file| require file }

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      # FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

  config.include Capybara::DSL
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Warden::Test::Helpers, type: :feature
  config.include FactoryGirl::Syntax::Methods
  config.include Features::SessionHelpers, type: :feature

  config.infer_spec_type_from_file_location!
end
