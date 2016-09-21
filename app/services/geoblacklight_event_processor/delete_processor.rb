class GeoblacklightEventProcessor
  class DeleteProcessor < Processor
    def process
      index.delete_by_query "uuid:#{RSolr.solr_escape(id)}"
      index.commit
      true
    end
  end
end
