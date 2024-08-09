# frozen_string_literal: true

module Blacklight
  module Response
    # Render a group of facet fields
    class FacetGroupComponent < Blacklight::Component
      # @param [Blacklight::Response] response
      # @param [Array<String>] fields facet fields to render
      # @param [String] title the title of the facet group section
      # @param [String] id a unique identifier for the group
      def initialize(response:, fields: [], title: nil, id: nil)
        @response = response
        @fields = fields
        @title = title
        @id = id ? "facets-#{id}" : "facets"
        @panel_id = id ? "facet-panel-#{id}-collapse" : "facet-panel-collapse"
      end

      def render?
        Deprecation.silence(Blacklight::FacetsHelperBehavior) do
          helpers.has_facet_values?(@fields, @response)
        end
      end

      def start_over_path(query_params = params)
        h = {}
        current_index_view_type = helpers.document_index_view_type(query_params)
        h[:view] = current_index_view_type unless current_index_view_type == helpers.default_document_index_view_type

        helpers.search_action_path(h)
      end
    end
  end
end
