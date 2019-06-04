class ThumbnailsController < ApplicationController
  include Blacklight::SearchHelper

  def index
    send_data thumbnail[:data], type: thumbnail[:type], disposition: 'inline'
  end

  private

    def thumbnail
      if Rails.cache.exist?("thumbnails/#{params[:id]}")
        Rails.cache.read("thumbnails/#{params[:id]}")
      else
        _response, @document = fetch params[:id]
        CacheThumbnailJob.perform_later(@document.to_h)
        placeholder
      end
    end

    def placeholder
      ThumbnailService.new(@document).placeholder
    end
end
