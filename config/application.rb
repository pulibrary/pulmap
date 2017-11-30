require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pulmap
  class Application < Rails::Application
    config.cache_store = :file_store, Rails.root.join("tmp", "thumbnails")
    config.active_job.queue_adapter = :async
    config.active_job.queue_adapter = ActiveJob::QueueAdapters::AsyncAdapter.new \
      min_threads: 1,
      max_threads: 2 * Concurrent.processor_count,
      idletime: 600.seconds
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
