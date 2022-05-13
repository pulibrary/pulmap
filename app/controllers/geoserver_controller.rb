# frozen_string_literal: true

class GeoserverController < ApplicationController
  def index
    url = Settings.INSTITUTION_GEOSERVER_URL
    url += "/geoserver/" unless /geoserver\/?$/.match?(url)
    url += "/" unless url.last == "/"
    path = params[:path]
    query = request.query_string
    uri = Addressable::URI.parse("#{url}#{path}?#{query}")

    proxied_response = Faraday.get(uri) do |req|
      req.headers["Authorization"] = Settings.PROXY_GEOSERVER_AUTH
    end

    # Get the status code
    status_code = proxied_response.status
    case status_code
    when 200..299
      proxy_success(proxied_response, status_code)
    when 300..399
      proxy_redirect(proxied_response, status_code)
    when 400..499
      Rails.logger.error("Authorization failure for GeoServer request: #{uri}: #{proxied_response.body}")
      head status_code
    when 500..599
      Rails.logger.error("Internal failure encountered for GeoServer request: #{uri}: #{proxied_response.body}")
      head status_code
    end
  end

  private

  def headers
    {
      "Authorization" => Settings.PROXY_GEOSERVER_AUTH
    }
  end

  def proxy_redirect(proxied_response, code)
    redirect_url = proxied_response["Location"]
    request_uri = Addressable::URI.parse(request.url)
    redirect_uri = Addressable::URI.parse(redirect_url)

    # Make redirect uri absolute if it's relative by
    # joining it with the request url
    redirect_uri = request_uri.join(redirect_url) if redirect_uri.host.nil?

    unless redirect_uri.port.nil?
      # Make sure it's consistent with our request port
      redirect_uri.port = request.port if redirect_uri.port == proxy_uri.port
    end

    redirect_to redirect_uri.to_s, status: code
  end

  def proxy_success(proxied_response, code)
    content_type = proxied_response["Content-Type"]
    body = proxied_response.body.to_s

    if content_type&.match(/image/)
      send_data body, content_type: content_type, disposition: "inline", status: code
    else
      render body: body, content_type: content_type, status: code
    end
  end
end
