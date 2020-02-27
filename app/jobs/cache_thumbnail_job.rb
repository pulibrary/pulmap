# frozen_string_literal: true

class CacheThumbnailJob < ApplicationJob
  queue_as :default

  def perform(document_hash)
    doc = SolrDocument.new(document_hash)
    ThumbnailService.new(doc).cache
  end
end
