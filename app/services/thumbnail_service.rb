class ThumbnailService
  def initialize(document)
    @document = document
  end

  # Caches the document's thumbnail image using ActiveSupport::Cache::Store.
  # @return [Boolean]
  def cache
    Rails.cache.write("thumbnails/#{@document.id}", thumbnail_data)
  end

  # Returns hash containing placeholder thumbnail for the document.
  # @return [Hash]
  #   * :type [String] image mime type
  #   * :data [String] image file data
  def placeholder
    placeholder_data
  end

  private

    # Returns geoserver auth credentials if the document is a restriced Princeton WMS layer.
    def geoserver_credentials
      return unless restricted_wms_layer?
      Settings.PROXY_GEOSERVER_AUTH.gsub('Basic ', '')
    end

    # Tests if geoserver credentials are set beyond the default.
    def geoserver_credentials_valid?
      Settings.PROXY_GEOSERVER_AUTH != "Basic base64encodedusername:password"
    end

    def placeholder_base_path
      Rails.root.join("app", "assets", "images")
    end

    # Generates hash containing placeholder mime_type and image.
    def placeholder_data
      { type: "image/png", data: placeholder_image }
    end

    # Gets placeholder image from disk.
    def placeholder_image
      File.read(placeholder_image_path)
    end

    # Path to placeholder image based on the layer geometry.
    def placeholder_image_path
      geom_type = @document.fetch("layer_geom_type_s", "").tr(" ", "-").downcase
      thumb_path = "#{placeholder_base_path}/thumbnail-#{geom_type}.png"
      return "#{placeholder_base_path}/thumbnail-paper-map.png" unless File.exist?(thumb_path)
      thumb_path
    end

    # Generates hash containing thumbnail mime_type and image.
    def thumbnail_data
      return placeholder_data unless thumbnail_url
      { type: "image/png", data: thumbnail_image }
    end

    # Gets thumbnail image from URL. On error, returns document's placeholder image.
    def thumbnail_image
      auth = geoserver_credentials
      conn = Faraday.new(url: thumbnail_url)
      conn.options.timeout = timeout
      conn.options.timeout = timeout
      conn.authorization :Basic, auth if auth
      conn.get.body
    rescue Faraday::Error::ConnectionFailed
      return placeholder_image
    rescue Faraday::Error::TimeoutError
      return placeholder_image
    end

    # Returns the thumbnail url.
    # If the layer is restriced Princeton WMS, and the geoserver credentials
    # have not been set beyond the default, then a thumbnail url from
    # dct references is used instead.
    def thumbnail_url
      @thumbnail_url ||= begin
        if restricted_scanned_map?
          thumbnail_reference
        elsif restricted_wms_layer? && !geoserver_credentials_valid?
          thumbnail_reference
        else
          service_url || thumbnail_reference
        end
      end
    end

    # Checks if the document is Princeton restriced access and is a scanned map.
    def restricted_scanned_map?
      @document.princeton_restricted? && @document['layer_geom_type_s'] == 'Image'
    end

    # Checks if the document is Princeton restriced access and is a wms layer.
    def restricted_wms_layer?
      @document.princeton_restricted? && @document.viewer_protocol == 'wms'
    end

    # Gets the url for a specific service endpoint if the item is
    # public, has the same institution as the GBL instance, and the viewer
    # protocol is not 'map' or nil. A module name is then dynamically generated
    # from the viewer protocol, and if it's loaded, the thumbnail_url
    # method is called.
    def service_url
      return unless @document.available?
      protocol = @document.viewer_protocol
      return if protocol == 'map' || protocol.nil?
      "ThumbnailService::#{protocol.camelcase}".constantize.thumbnail_url(@document, thumbnail_size)
    rescue NameError
      return nil
    end

    # Retreives a url to a static thumbnail from the document's dct_references field, if it exists.
    def thumbnail_reference
      JSON.parse(@document[@document.references.reference_field])['http://schema.org/thumbnailUrl']
    end

    # Default thumbnail size.
    def thumbnail_size
      77
    end

    # Faraday timeout value.
    def timeout
      30
    end
end
