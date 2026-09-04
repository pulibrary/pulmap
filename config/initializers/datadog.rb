# frozen_string_literal: true

Datadog.configure do |c|
  c.tracing.enabled = false unless Rails.env.production?
  # the tracing info injected into logs is messing with log parsing in signoz
  c.tracing.log_injection = false
  c.env = Rails.env.to_s
  c.service = "pulmap"

  # Rails
  c.tracing.instrument :rails

  # Redis
  c.tracing.instrument :redis

  # Net::HTTP
  c.tracing.instrument :http

  # Sidekiq
  c.tracing.instrument :sidekiq

  # Faraday
  c.tracing.instrument :faraday
end
