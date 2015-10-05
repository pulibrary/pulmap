module ApplicationHelper
  def home_layout?
    geoblacklight_map_type == 'home'
  end

  def geoblacklight_map_type
    if params[:action] == 'show'
      'item'
    elsif params[:action] == 'index'
      if has_search_parameters?
        'index'
      else
        'home'
      end
    end
  end
end
