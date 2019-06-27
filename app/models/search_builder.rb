# frozen_string_literal: true

class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include BlacklightRangeLimit::RangeLimitBuilder
  include Geoblacklight::SpatialSearchBehavior
  include ::FeaturedContentBehavior

  self.default_processor_chain += %i[add_advanced_parse_q_to_solr add_advanced_search_to_solr
                                     hide_suppressed_records add_featured_content]

  def hide_suppressed_records(solr_params)
    # Show child records if searching for a specific source parent
    return unless blacklight_params.fetch(:f, {})[:dc_source_sm].nil?
    solr_params[:fq] ||= []
    solr_params[:fq] << '-suppressed_b: true'
  end
end
