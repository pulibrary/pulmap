module WmsThumbnail
  ##
  # Formats and returns a thumbnail url from a Web Map Service endpoint.
  # This utilizes the GeoServer specific 'reflect' service to generate
  # parameters like bbox that are difficult to tweak without more detailed
  # information about the layer.
  # @param [SolrDocument]
  # @param [Integer] thumbnail size
  # @return [String] wms thumbnail url
  def self.thumbnail_url(document, size)
    "#{document.thumbnail_generator_endpoint}/reflect?" \
      '&FORMAT=image%2Fpng' \
      '&TRANSPARENT=TRUE' \
      "&LAYERS=#{document['layer_id_s']}" \
      "&WIDTH=#{size}" \
      "&HEIGHT=#{size}"
  end
end
