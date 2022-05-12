# frozen_string_literal: true

require File.expand_path('../boot', __FILE__)

require 'rails/all'
require_relative 'lando_env'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pulmap
  class Application < Rails::Application
    require 'sidekiq_chart'

    config.cache_store = :file_store, Rails.root.join("tmp", "thumbnails")
    config.robots = OpenStruct.new(config_for(:robots))

    # Configure user ids that are authorized for admin tasks
    config.authorization = []
    authorization = config_for(:authorization)
    netids = authorization["netids"]
    config.authorization = netids.split if netids
  end
end
