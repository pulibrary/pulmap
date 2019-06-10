class ThumbnailsController < ApplicationController
  def index
    send_data thumbnail[:data], type: thumbnail[:type], disposition: 'inline'
  end

  private

    # Replace with Blacklight::Searchable when BL version is >= 7.1
    def search_service
      Blacklight::SearchService.new(config: blacklight_config, user_params: search_state.to_h, **search_service_context)
    end

    # Replace with Blacklight::Searchable when BL version is >= 7.1
    def search_service_context
      {}
    end

    def thumbnail
      if Rails.cache.exist?("thumbnails/#{params[:id]}")
        Rails.cache.read("thumbnails/#{params[:id]}")
      else
        _response, @document = search_service.fetch params[:id]
        CacheThumbnailJob.perform_later(@document.to_h)
        placeholder
      end
    end

    def placeholder
      ThumbnailService.new(@document).placeholder
    end
end
