# frozen_string_literal: true
require 'rails_helper'

describe Geoblacklight::SolrDocument do
  describe '#geoblacklight_citation' do
    context 'when creating a citation for a Princeton record' do
      it 'creates a Princeton specific citation' do
        document = SolrDocument.find('princeton-m613n013z')
        citation = document.geoblacklight_citation('http://example.com')
        expect(citation).to include 'The Princeton University Library makes available'
        expect(citation).to include 'Louisiana Tracts 2002, Maps and Geospatial Data, Princeton University Library'
      end
    end
    context 'when creating a citation for a non-Princeton record' do
      it 'creates a generic citation' do
        document = SolrDocument.find('tufts-cambridgegrid100-04')
        citation = document.geoblacklight_citation('http://example.com')
        expect(citation).not_to include 'The Princeton University Library makes available'
        expect(citation).to include '100 Foot Grid Cambridge MA 2004. [Shapefile]. Cambridge (Mass.)'
      end
    end
  end
end
