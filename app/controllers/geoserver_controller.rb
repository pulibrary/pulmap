class GeoserverController < ApplicationController
  include ReverseProxy::Controller

  def index
    reverse_proxy Settings.PRINCETON_GEOSERVER_URL, headers: headers
  end

  private

    def headers
      {
        'Authorization' => Settings.PROXY_GEOSERVER_AUTH
      }
    end
end
