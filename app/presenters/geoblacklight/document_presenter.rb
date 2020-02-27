# frozen_string_literal: true

module Geoblacklight
  ##
  # Adds custom functionality for Geoblacklight document presentation
  class DocumentPresenter < Blacklight::IndexPresenter
    include ActionView::Helpers::OutputSafetyHelper
    ##
    # Presents configured index fields in search results. Passes values through
    # configured helper_method. Multivalued fields separated by presenter
    # field_value_separator (default: comma). Fields separated by period.
    # @return [String]
    def index_fields_display
      fields_values = []
      @configuration.index_fields.each_value do |field|
        val = field_value(field)
        if val.present?
          val += '.' unless val.end_with?('.')
          fields_values << val
        end
      end
      safe_join(fields_values, ' ')
    end
  end
end
