module ThumbnailHelper
  def gbl_thumbnail_img(document, image_wh = 250)
    url = gbl_thumbnail_url(document, image_wh)

    if url
      h = "<img class='item-thumbnail' data-src='#{gbl_thumbnail_url(document)}'>"
      h += geoblacklight_icon(document['layer_geom_type_s'])
    else
      h = geoblacklight_icon(document['layer_geom_type_s'])
    end
    h.html_safe
  end

  # get thumbnail url from dctrefs, if not in dctrefs, then
  # from a WMS, IIIF service
  def gbl_thumbnail_url(document, image_wh = 250)
    thumbnail_reference(document) || thumbnail_service_url(document, image_wh)
  end

  def gbl_thumbnail_bbox(document)
    bbox = document.bounding_box_as_wsen.split(' ').collect!(&:to_f)
    gbl_enlarge_bbox(bbox).join(',')
  end

  def gbl_enlarge_bbox(bbox)
    ns = ((bbox[3] - bbox[1]).abs)
    scale_factor = ns / 4
    bbox[2] = bbox[2] + scale_factor
    bbox[0] = bbox[0] - scale_factor
    bbox[3] = bbox[3] + scale_factor
    bbox[1] = bbox[1] - scale_factor
    bbox
  end

  # workaround for lack of thumbnail in constants class
  def thumbnail_reference(document)
    JSON.parse(document[document.references.reference_field])['http://schema.org/thumbnailUrl']
  end

  def thumbnail_service_url(document, image_wh)
    return unless document.available?
    protocol = document.viewer_protocol
    method("#{protocol}_thumbnail_url").call(document, image_wh) unless protocol == 'map'
  end

  def wms_thumbnail_url(document, image_wh)
    "#{document.viewer_endpoint}?SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&FORMAT=image%2Fpng" \
    '&TRANSPARENT=TRUE' \
    "&LAYERS=#{document['layer_id_s']}" \
    "&WIDTH=#{image_wh}" \
    "&HEIGHT=#{image_wh}" \
    "&BBOX=#{gbl_thumbnail_bbox(document)}".html_safe
  end

  def iiif_thumbnail_url(document, image_wh)
    "#{document.viewer_endpoint.gsub('info.json', '')}full/#{image_wh},/0/default.jpg"
  end
end
