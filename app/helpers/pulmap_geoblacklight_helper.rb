module PulmapGeoblacklightHelper
  include GeoblacklightHelper

  def document_available?
    (@document.public? && @document.available?) || (@document.same_institution? &&
                                                    user_signed_in? &&
                                                    @document.available?)
  end

  def viewer_container
    if @document.references.references(:iiif_manifest)
      manifest_viewer
    else
      leaflet_viewer
    end
  end

  def all_facet_values_label(field)
    field_config = blacklight_config.facet_fields[field]
    field_config[:all] || 'All types'
  end

  def remove_all_facet_values(field)
    p = search_state.to_h.dup
    p[:f] = (p[:f] || {}).dup
    p[:f].delete(field)
    p.delete(:f) if p[:f].empty?
    p
  end

  def facet_active(facet_field)
    if facet_field_in_params?(facet_field)
      ' active'
    else
      ''
    end
  end

  private

  def leaflet_viewer
    content_tag(:div, nil, id: 'map',
                           data: { map: 'item', protocol: @document.viewer_protocol.camelize,
                                   url: @document.viewer_endpoint,
                                   'layer-id' => @document.wxs_identifier,
                                   'map-bbox' => @document.bounding_box_as_wsen,
                                   'catalog-path' => search_catalog_path,
                                   available: document_available?,
                                   basemap: geoblacklight_basemap,
                                   leaflet_options: leaflet_options })
  end

  def viewer_tags(classes)
    content_tag(:div, nil,
                class: classes,
                data: {
                  uri: @document.references.references(:iiif_manifest).endpoint,
                  config: asset_url('uv/uv_config.json')
                }) + PulUvRails::UniversalViewer.script_tag
  end

  def manifest_viewer
    safe_join [viewer_tags(%w(view uv)), viewer_tags(%w(view uv hidden))]
  end
end
