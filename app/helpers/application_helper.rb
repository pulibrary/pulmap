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
    if params[:action] == 'show'
      'item'
    elsif params[:action] == 'index'
      params[:q].present? ? 'index' : 'home'
    end
  end
end
