# frozen_string_literal: true

class GeoblacklightEventHandler
  include Sneakers::Worker
  from_queue :pulmap

  def work(msg)
    msg = JSON.parse(msg)
    IndexJob.perform_later(msg)
    ack!
  end
end
