module Geoblacklight
  class BboxItemPresenter < Blacklight::FacetItemPresenter
    def field_label
      I18n.t("geoblacklight.bbox_label")
    end

    def label
      super.to_param
    end
  end
end
