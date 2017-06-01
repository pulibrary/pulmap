# frozen_string_literal: true
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightRangeLimit::RangeLimitBuilder
  include Geoblacklight::SpatialSearchBehavior

  self.default_processor_chain += [:hide_suppressed_records]

  def hide_suppressed_records(solr_params)
    # Show child records if searching for a specific source parent
    return unless blacklight_params.fetch(:f, {})[:dct_source_sm].nil?
    solr_params[:fq] ||= []
    solr_params[:fq] << '-suppressed_b: true'
  end
end
