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

  ##
  # Gets current layout for use in rendering partials
  # @return [String] item, index, home, or default
  def layout_type
    if params[:controller] == 'catalog'
      if params[:action] == 'show'
        'item'
      elsif params[:action] == 'index'
        has_search_parameters? ? 'index' : 'home'
      end
    else
      'default'
    end
  end
end
