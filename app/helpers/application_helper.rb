module ApplicationHelper
  ##
  # Checks if index is the current layout
  # @return [Boolean]
  def home_layout?
    layout_type == 'home'
  end

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
      'navbar-fixed-top'
    else
      'navbar'
    end
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
end
