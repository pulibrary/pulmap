# frozen_string_literal: true

module SanbornConcern
  extend Geoblacklight::SolrDocument

  def published_by_sanborn?
    if key?(Settings.FIELDS.PUBLISHER)
      fetch(Settings.FIELDS.PUBLISHER).downcase.include?('sanborn')
    else
      false
    end
  end
end
