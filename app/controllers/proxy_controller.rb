# frozen_string_literal: true

class ProxyController < ApplicationController
  # before_action :validate_user

  def index
    url = Pulmap.config["geodata_url"]
    url += "/" unless url.last == "/"
    path = params[:path] + "." + params[:format]
    uri = Addressable::URI.parse("#{url}#{path}")
    range = request.get_header("HTTP_RANGE")

    proxied_response = Faraday.get(uri) do |req|
      req.headers["Range"] = range if range
    end

    # Get the status code
    status_code = proxied_response.status
    case status_code
    when 200..299
      proxy_success(proxied_response, status_code)
    when 400..499
      Rails.logger.error("Authorization failure for geodata request: #{uri}: #{proxied_response.body}")
      head status_code
    when 500..599
      Rails.logger.error("Internal failure encountered for geodata request: #{uri}: #{proxied_response.body}")
      head status_code
    end
  end

  private

  def proxy_success(proxied_response, code)
    response.headers["Content-Length"] = proxied_response["Content-Length"]
    content_type = proxied_response["Content-Type"]
    body = proxied_response.body
    # send_data body, content_type: content_type, disposition: "inline", status: code
    render body: body, content_type: content_type, status: code
  end

  # def validate_user
  #   return if current_user
  #   head 401
  # end
end
