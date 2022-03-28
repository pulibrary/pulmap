# frozen_string_literal: true

class GeoblacklightEventProcessor
  class UpdateProcessor < Processor
    def process
      doc.delete("_aj_symbol_keys")
      data = doc.to_json
      index.update params: { overwrite: true },
                   data: data,
                   headers: { 'Content-Type' => 'application/json' }
      result = index.commit unless bulk?
      logger.info result
    end
  end
end
