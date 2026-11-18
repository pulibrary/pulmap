# frozen_string_literal: true

require File.expand_path("../boot", __FILE__)

require "rails/all"
require_relative "lando_env"
require_relative "../lib/middleware/retired_paths"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pulmap
  class Application < Rails::Application
    config.cache_store = :file_store, Rails.root.join("tmp", "thumbnails")
    config.robots = OpenStruct.new(config_for(:robots))

    # Configure user ids that are authorized for admin tasks
    config.authorization = []
    authorization = config_for(:authorization)
    netids = authorization["netids"]
    config.authorization = netids.split if netids

    # Catch calls to retired paths before logging
    config.middleware.insert_before 0, Middleware::RetiredPaths

    config.active_record.yaml_column_permitted_classes = [ Symbol, Date, Time, Hash, HashWithIndifferentAccess ]
  end
end
