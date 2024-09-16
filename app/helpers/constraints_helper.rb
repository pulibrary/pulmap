# frozen_string_literal: true

module ConstraintsHelper
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
      path = search_action_path(remove_spatial_filter_group(:featured, localized_params))
      content << render_constraint_element(t("pulmap.search.filters.featured_label"),
                                           value, remove: path)
    end

    content
  end
end
