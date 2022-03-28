# frozen_string_literal: true

class GeoblacklightEventProcessor
  class DeleteProcessor < Processor
    def process
      raise "Delete Processor"
      index.delete_by_query "layer_slug_s:#{RSolr.solr_escape(id)}"
      index.commit unless bulk?
      true
    end
  end
end
