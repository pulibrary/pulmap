module PulmapGeoblacklightHelper
  include GeoblacklightHelper
  # Render a label/value constraint on the screen. Can be called
  # by plugins and such to get application-defined rendering.
  #
  # Can pass in nil label if desired.
  # @see Blacklight::RenderConstraintsHelperBehavior#render_constraint_element
  #
  # @param [String] label to display
  # @param [String] value to display
  # @param [Hash] options
  # @option options [String] :remove url to execute for a 'remove' action
  # @option options [Array<String>] :classes an array of classes to add to container span.
  # @return [String]
  def render_constraint_element(label, value, options = {})
    value = nil if params[:bbox] && label == t('pulmap.search.bbox.label')
    super(label, value, options)
  end

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
    content_tag(:div, nil,
                id: 'view',
                data: { manifest: @document.references.references(:iiif_manifest).endpoint })
  end
end
