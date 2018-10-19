require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pulmap
  class Application < Rails::Application
    require 'sidekiq_chart'

    config.cache_store = :file_store, Rails.root.join("tmp", "thumbnails")
    config.active_job.queue_adapter = if Rails.env == "production"
                                        :sidekiq
                                      else
                                        :async
                                      end
    config.robots = OpenStruct.new(config_for(:robots))
    config.active_record.sqlite3.represent_boolean_as_integer = true
  end
end
