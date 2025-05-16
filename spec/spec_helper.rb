# frozen_string_literal: true

ENV["RACK_ENV"] = "test"
require "webmock/rspec"
require "simplecov"
require "capybara/rspec"
require "capybara-screenshot/rspec"
require "selenium-webdriver"

SimpleCov.start "rails" do
  add_filter "/spec"
  # TODO: Add full coverage for geoserver reverse proxy functionality.
  # This is difficult to test at the moment and could use refactoring in the future.
  add_filter "app/controllers/geoserver_controller.rb"
  minimum_coverage 100
end

SimpleCov.formatter = if ENV["CI"] == "true"
                        SimpleCov::Formatter::MultiFormatter.new(
                          [
                            SimpleCov::Formatter::HTMLFormatter
                          ]
                        )
else
                        SimpleCov::Formatter::HTMLFormatter
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

WebMock.disable_net_connect!(allow_localhost: true,
                             net_http_connect_on_start: true,
                             allow: [ "chromedriver.storage.googleapis.com", "googlechromelabs.github.io",
                                     "storage.googleapis.com",
                                     "edgedl.me.gvt1.com" ])
