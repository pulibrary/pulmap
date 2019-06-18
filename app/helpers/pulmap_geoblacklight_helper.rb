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

  def facet_fields_show
    facet_field_names.each do |f|
      return 'show' if facet_field_in_params?(f)
    end
  end

  def data_download_text(format)
    download_format = proper_case_format(format)
    value = t('geoblacklight.data_download.download_link', download_format: download_format)
    value.html_safe
  end

  # Overrides method in Blacklight::UrlHelperBehavior
  # https://github.com/projectblacklight/blacklight/blob/v7.0.1/app/helpers/blacklight/url_helper_behavior.rb#L47
  def link_to_previous_document(previous_document)
    link_opts = session_tracking_params(previous_document, search_session['counter'].to_i - 1).merge(class: "previous", rel: 'prev')
    link_to_unless previous_document.nil?, raw(t('blacklight.pagination_compact.previous').html_safe), url_for_document(previous_document), link_opts do
      content_tag :span, raw(t('blacklight.pagination_compact.previous').html_safe), class: 'previous'
    end
  end

  # Overrides method in Blacklight::UrlHelperBehavior
  # https://github.com/projectblacklight/blacklight/blob/v7.0.1/app/helpers/blacklight/url_helper_behavior.rb#L56
  def link_to_next_document(next_document)
    link_opts = session_tracking_params(next_document, search_session['counter'].to_i + 1).merge(class: "next", rel: 'next')
    link_to_unless next_document.nil?, raw(t('blacklight.pagination_compact.next').html_safe), url_for_document(next_document), link_opts do
      content_tag :span, raw(t('blacklight.pagination_compact.next').html_safe), class: 'next'
    end
  end

  # Overrides method in Blacklight::UrlHelperBehavior
  # https://github.com/projectblacklight/blacklight/blob/v7.0.1/app/helpers/blacklight/url_helper_behavior.rb#L124
  def link_back_to_catalog(opts = { label: nil })
    scope = opts.delete(:route_set) || self
    query_params = current_search_session.try(:query_params) || ActionController::Parameters.new

    if search_session['counter']
      per_page = (search_session['per_page'] || default_per_page).to_i
      counter = search_session['counter'].to_i

      query_params[:per_page] = per_page unless search_session['per_page'].to_i == default_per_page
      query_params[:page] = ((counter - 1) / per_page) + 1
    end

    link_url = if query_params.empty?
                 search_action_path(only_path: true)
               else
                 scope.url_for(query_params)
               end
    label = opts.delete(:label)

    label ||= t('blacklight.back_to_bookmarks') if link_url =~ /bookmarks/

    label ||= t('blacklight.back_to_search').html_safe

    link_to label, link_url, opts
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
      safe_join [viewer_tags(%w[view uv]), viewer_tags(%w[view uv d-none])]
    end
end
