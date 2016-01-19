module ThumbnailHelper
  def gbl_thumbnail_img(document, image_width = 100)
    url = gbl_thumbnail_url(document, image_width)

    if url
      h = image_tag(gbl_thumbnail_url(document, image_width), alt: 'document title')
    else
      h = geoblacklight_icon(document['layer_geom_type_s'])
    end
    h.html_safe
  end

  # get thumbnail url from dctrefs, if not in dctrefs, then
  # from a WMS, IIIF service
  def gbl_thumbnail_url(document, image_width = 100)
    dimensions = gbl_thumbnail_dimensions(document, image_width)
    thumbnail_reference(document) || thumbnail_service_url(document, dimensions)
  end

  def gbl_thumbnail_bbox(document)
    document.bounding_box_as_wsen.split(' ').collect!(&:to_f)
  end

  # return hash {width, height})
  def gbl_thumbnail_dimensions(document, image_width = 100)
    bbox = gbl_thumbnail_bbox(document)

    # |north - south| / (|east - west| * 2) * thumb_width
    calc_height = (((bbox[3] - bbox[1]).abs / (bbox[2] - bbox[0]).abs * 2) * image_width).to_i
    { width: image_width, height: calc_height }
  end

  # workaround for lack of thumbnail in constants class
  def thumbnail_reference(document)
    JSON.parse(document[document.references.reference_field])['http://schema.org/thumbnailUrl']
  end

  def thumbnail_service_url(document, dimensions)
    return unless document.available?
    protocol = document.viewer_protocol
    method("#{protocol}_thumbnail_url").call(document, dimensions) unless protocol == 'map'
  end

  def wms_thumbnail_url(document, dimensions)
    "#{document.viewer_endpoint}?SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&FORMAT=image%2Fpng" \
    '&TRANSPARENT=TRUE' \
    "&LAYERS=#{document['layer_id_s']}" \
    "&WIDTH=#{dimensions[:width]}" \
    "&HEIGHT=#{dimensions[:height]}" \
    "&BBOX=#{document.bounding_box_as_wsen.tr(' ', ',')}"
  end

  def iiif_thumbnail_url(document, dimensions)
    "#{document.viewer_endpoint.gsub('info.json', '')}full/#{dimensions[:width]},/0/default.jpg"
  end
end
