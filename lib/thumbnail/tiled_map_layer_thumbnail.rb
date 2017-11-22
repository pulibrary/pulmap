module TiledMapLayerThumbnail
  ##
  # Formats and returns a thumbnail url from an ESRI Tiled Map Layer endpoint.
  # @param [SolrDocument]
  # @param [Integer] thumbnail size
  # @return [String] thumbnail url
  def self.thumbnail_url(document, _size)
    "#{document.viewer_endpoint}/info/thumbnail/thumbnail.png"
  end
end
