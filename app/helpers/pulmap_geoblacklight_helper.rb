# frozen_string_literal: true

module PulmapGeoblacklightHelper
  include GeoblacklightHelper

  def document_available?
    (@document.public? && @document.available?) || (@document.same_institution? &&
                                                    user_signed_in? &&
                                                    @document.available?)
  end

  def viewer_container
    if openlayers_container?
      ol_viewer
    elsif @document.references.references(:iiif_manifest)
      manifest_viewer
    else
      leaflet_viewer
    end
  end

  def openlayers_container?
    return false unless @document
    @document.item_viewer.pmtiles || @document.item_viewer.cog
  end

  def all_facet_values_label(field)
    field_config = blacklight_config.facet_fields[field]
    field_config[:all] || "All types"
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
      " facet-limit-active"
    else
      ""
    end
  end

  def data_download_text(format)
    download_format = proper_case_format(format)
    value = t("geoblacklight.data_download.download_link", download_format: download_format)
    value.html_safe
  end

  # Check's if an item's call number matches those from the historic map collection.
  # @return [Bool]
  def princeton_historic_map?
    call_number = @document["call_number_s"]
    return unless @document.same_institution? && call_number
    /HMC/i.match(call_number)
  end

  def princeton_provenance(args)
    return args[:value]&.first unless princeton_historic_map?
    "Princeton: Historic Map Division, Special Collections, Firestone Library"
  end

  def html_safe(args)
    args[:document][args[:field]].html_safe
  end

  private

  def leaflet_viewer
    tag.div(nil,
            id: "map",
            data: {
              map: "item", protocol: @document.viewer_protocol.camelize,
                    url: @document.viewer_endpoint,
                    "layer-id" => @document.wxs_identifier,
                    "map-geom" => @document.geometry.geojson,
                    "catalog-path" => search_catalog_path,
                    available: document_available?,
                    basemap: geoblacklight_basemap,
                    leaflet_options: leaflet_options
            })
  end

  def ol_viewer
    tag.div(nil,
            id: "ol-map",
            data: {
              map: "item", protocol: @document.viewer_protocol.camelize,
                    url: @document.viewer_endpoint,
                    "layer-id" => @document.wxs_identifier,
                    "map-geom" => @document.geometry.geojson,
                    "catalog-path" => search_catalog_path,
                    available: document_available?,
                    basemap: geoblacklight_basemap,
                    leaflet_options: leaflet_options
            })
  end

  def manifest_viewer
    tag.div nil, class: "uv" do
      tag.iframe nil,
                  allowfullscreen: true,
                  src: "#{Pulmap.config['figgy_universal_viewer_url']}#?manifest=#{@document.references.references(:iiif_manifest).endpoint}&config=#{Pulmap.config['figgy_universal_viewer_config']}"
    end
  end
end
