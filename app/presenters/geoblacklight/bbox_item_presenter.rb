# frozen_string_literal: true
module Geoblacklight
  class BboxItemPresenter < Blacklight::FacetItemPresenter
    def field_label
      "Bounding Box"
    end

    def label
      I18n.t("geoblacklight.bbox_label")
    end
  end
end
