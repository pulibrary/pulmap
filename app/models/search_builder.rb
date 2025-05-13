# frozen_string_literal: true

class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightRangeLimit::RangeLimitBuilder
  # include Geoblacklight::SpatialSearchBehavior
  include Geoblacklight::SuppressedRecordsSearchBehavior
  include ::FeaturedContentBehavior

  self.default_processor_chain += %i[add_featured_content]
end
