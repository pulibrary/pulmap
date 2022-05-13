# frozen_string_literal: true

class GeoblacklightEventProcessor
  class UnknownEvent < Processor
    def process
      Rails.logger.info("Unable to process event type #{event_type}")
      true
    end
  end
end
