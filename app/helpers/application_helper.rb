# frozen_string_literal: true

module ApplicationHelper
  ##
  # Checks if index is the current layout
  # @return [Boolean]
  def index_layout?
    layout_type == 'index'
  end

  ##
  # Checks if item is the current layout
  # @return [Boolean]
  def item_layout?
    layout_type == 'item'
  end

  ##
  # Checks if default is the current layout
  # @return [Boolean]
  def default_layout?
    layout_type == 'default'
  end

  def container_type
    if index_layout?
      'container-fluid'
    else
      'container'
    end
  end

  def navbar_type
    if index_layout?
      'navbar-expand-md fixed-top'
    else
      'navbar-expand-md'
    end
  end

  def hide_constraints?
    skip_params = constraint_params_to_skip
    skip_params << 'q' if params[:q]&.empty?
    params.reject { |p| skip_params.include?(p) }.empty?
  end

  def constraint_params_to_skip
    %w[
      page
      per_page
      search_field
      sort
      controller
      action
      utf8
    ]
  end

  ##
  # Gets current layout for use in rendering partials
  # @return [String] item, index, home, or default
  def layout_type
    if params[:controller] == 'catalog'
      if params[:action] == 'show' || params[:action] == 'downloads'
        'item'
      elsif params[:action] == 'index'
        'index'
      end
    else
      'default'
    end
  end

  # rubocop:disable Rails/OutputSafety
  def placeholder_thumbnail_icon(name, document)
    icon_name = name ? name.to_s.parameterize : 'none'
    # Cases where 'vector' is generated for the icon name
    # This may actually be a problem with the data (please see https://github.com/pulibrary/pulmap/issues/844)
    icon_name = 'polygon' if icon_name == 'vector'

    icon = Blacklight::Icon.new(icon_name)
    icon.svg.html_safe
    link_to icon.svg.html_safe, url_for_document(document), document_link_params(document, {})
  rescue Blacklight::Exceptions::IconNotFound
    link_to Blacklight::Icon.new('mixed').svg.html_safe, url_for_document(document), document_link_params(document, {})
  end
  # rubocop:enable Rails/OutputSafety
end
