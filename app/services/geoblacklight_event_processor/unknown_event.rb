# frozen_string_literal: true

class GeoblacklightEventProcessor
  class UnknownEvent < Processor
    attr_reader :event
    def initialize(event)
      @event = event
    end

    def process
      Rails.logger.info("Unable to process event type #{event_type}")
      true
    end
  end
end
