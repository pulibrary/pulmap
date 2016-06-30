module ThumbnailHelper
  ##
  # Returns html for displaying a geoblacklight thumbnail. If there isn't a
  # thumbnail url, a placeholder showing the geometry type is displayed. If there
  # is a thumbnail url, a placeholder is displayed along with an image tag. The
  # thumbnail image is then loaded asynchronously via javascript.
  # @param [SolrDocument]
  # @return [String]
  def gbl_thumbnail_img(document)
    url = document.thumbnail_url
    if url
      h = "<img class='item-thumbnail' data-aload='#{url}'>"
      h += geoblacklight_icon(document['layer_geom_type_s'])
    else
      h = geoblacklight_icon(document['layer_geom_type_s'])
    end
    h.html_safe
  end
end
