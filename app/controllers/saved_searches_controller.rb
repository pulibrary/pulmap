# frozen_string_literal: true
class SavedSearchesController < ApplicationController
  include Blacklight::SavedSearches

  helper BlacklightRangeLimit::ViewHelperOverride
  helper RangeLimitHelper
end
