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
  # Gets current layout for use in rendering partials
  # @return [String] item, index, or home
  def layout_type
    # has search parameters method fails in history page
    if current_page?(search_history_path)
      'item'
    elsif has_search_parameters?
      'index'
    elsif current_page?(root_url)
      'home'
    else
      'item'
    end
  end
end
