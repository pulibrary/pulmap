# frozen_string_literal: true
class IndexJob < ApplicationJob
  queue_as :high

  def perform(message)
    GeoblacklightEventProcessor.new(message).process
  end
end
