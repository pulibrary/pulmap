class GeoblacklightEventProcessor
  class UpdateProcessor < Processor
    def process
      index.update params: { overwrite: true },
                   data: [doc].to_json,
                   headers: { 'Content-Type' => 'application/json' }
      index.commit
      true
    rescue RSolr::Error::Http
      false
    end
  end
end
