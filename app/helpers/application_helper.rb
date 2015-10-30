module ApplicationHelper
  ##
  # Checks if home is the current layout
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
  # Checks if item is the current layout
  # @return [Boolean]
  def bookmarks_layout?
    layout_type == 'bookmarks'
  end

  ##
  # Gets current layout for use in rendering partials
  # @return [String] item, index, home, or bookmarks
  def layout_type
    if %w(search_history bookmarks).include? params[:controller]
      'bookmarks'
    elsif params[:action] == 'show'
      'item'
    elsif params[:action] == 'index'
      has_search_parameters? ? 'index' : 'home'
    end
  end
end
