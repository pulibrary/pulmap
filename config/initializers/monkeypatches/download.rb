module Geoblacklight
  # Overridden from: https://github.com/geoblacklight/geoblacklight/blob/v3.8.0/lib/geoblacklight/download.rb
  class Download
    ##
    # Monkey patch of Geoblacklight::Download that injects geoserver auth
    # credentials for restriced princeton wms layers. Delete this as soon as
    # geoblacklight downloads become configurable or multiple direct downloads
    # are integrated into the document schema.
    def initiate_download
      auth = geoserver_credentials
      conn = Faraday.new(url: url)
      conn.authorization :Basic, auth if auth
      conn.get do |request|
        request.params = @options[:request_params]
        request.options.timeout = timeout
        request.options.open_timeout = timeout
      end
    rescue Faraday::ConnectionFailed
      raise Geoblacklight::Exceptions::ExternalDownloadFailed,
            message: "Download connection failed",
            url: conn.url_prefix.to_s
    rescue Faraday::TimeoutError
      raise Geoblacklight::Exceptions::ExternalDownloadFailed,
            message: "Download timed out",
            url: conn.url_prefix.to_s
    rescue Faraday::SSLError
      raise Geoblacklight::Exceptions::ExternalDownloadFailed,
        message: "Download connection failed due to an error related to TLS (encryption)",
        url: conn.url_prefix.to_s
    end

  private

    def geoserver_credentials
      return unless restricted_wms_layer?
      Settings.PROXY_GEOSERVER_AUTH.gsub("Basic ", "")
    end

    # Checks if the document is Princeton restriced access and is a wms layer.
    def restricted_wms_layer?
      @document.local_restricted? && @document.viewer_protocol == "wms"
    end
  end
end
