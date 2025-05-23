# frozen_string_literal: true

Rails.application.config.after_initialize do
  HealthMonitor.configure do |config|
    config.cache

    config.add_custom_provider(CheckOverrides::Redis)
    config.add_custom_provider(SolrStatus)
    config.add_custom_provider(SmtpStatus)

    # Make this health check available at /health
    config.path = :health

    config.error_callback = proc do |e|
      Rails.logger.error "Health check failed with: #{e.message}"
    end
  end
end
