# frozen_string_literal: true

module ConstraintsHelper
  def render_constraints(localized_params = params, local_search_state = search_state)
    super(localized_params, local_search_state)
  end

  def query_has_constraints?(localized_params = params)
    !(localized_params[:q].blank? && localized_params[:f].blank? && localized_params[:featured].blank?)
  end

  def render_constraint_element(label, value, options = {})
    if params[:bbox]
      value = nil if label == t("geoblacklight.bbox_label")
    end
    super(label, value, options)
  end

  def render_constraints_filters(localized_params = params)
    content = super(localized_params)
    localized_params = localized_params.to_h unless localized_params.is_a?(Hash)

    if localized_params[:featured]
      value = localized_params[:featured].humanize.split.map(&:capitalize).join(" ")
      localized_params.delete("featured")
      remove_path = search_action_path(localized_params)
      content << render_constraint_element(t("pulmap.search.filters.featured_label"),
                                           value, remove: remove_path)
    end

    content
  end
end
