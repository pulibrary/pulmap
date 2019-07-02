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
      ' facet-limit-active'
    else
      ''
    end
  end

  def data_download_text(format)
    download_format = proper_case_format(format)
    value = t('geoblacklight.data_download.download_link', download_format: download_format)
    value.html_safe
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

    def manifest_viewer
      content_tag :div, nil, class: "uv" do
        content_tag :iframe, nil,
                    allowfullscreen: true,
                    src: "#{Pulmap.config['figgy_universal_viewer_url']}#?manifest=#{@document.references.references(:iiif_manifest).endpoint}&config=#{Pulmap.config['figgy_universal_viewer_config']}"
      end
    end
end
