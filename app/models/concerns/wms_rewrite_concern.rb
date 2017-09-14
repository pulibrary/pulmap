module WmsRewriteConcern
  extend Geoblacklight::SolrDocument

  def viewer_endpoint
    if princeton_restricted?
      # replace wms prefix with cas authed proxy
      super.gsub(Settings.PRINCETON_GEOSERVER_URL, Settings.PROXY_GEOSERVER_URL)
    else
      super
    end
  end

  def princeton_restricted?
    princeton? && restricted?
  end

  def princeton?
    fetch(:dct_provenance_s, '').casecmp('princeton').zero?
  end
end
