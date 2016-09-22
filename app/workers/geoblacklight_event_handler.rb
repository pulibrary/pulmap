class GeoblacklightEventHandler
  include Sneakers::Worker
  from_queue :pulmap

  def work(msg)
    msg = JSON.parse(msg)
    result = GeoblacklightEventProcessor.new(msg).process
    if result
      ack!
    else
      reject!
    end
  end
end
