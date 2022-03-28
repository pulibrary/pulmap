# frozen_string_literal: true
require_relative "redis_config"
Sidekiq.logger = Logger.new(STDOUT)
Sidekiq.configure_server do |config|
  config.redis = { url: RedisConfig.url }
  config.logger.level = Logger::DEBUG
end

Sidekiq.configure_client do |config|
  config.redis = { url: RedisConfig.url }
  config.logger.level = Logger::DEBUG
end
