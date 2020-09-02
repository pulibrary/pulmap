# frozen_string_literal: true
require_relative "production"

Rails.application.configure do
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
end
