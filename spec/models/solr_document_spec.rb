require 'rails_helper'

describe SolrDocument do
  let(:document) { described_class.new(document_attributes) }
  let(:document_attributes) { { dct_references_s: refs } }
  let(:refs) { '{"http://schema.org/thumbnailUrl":"http://example.com/thumb.jpg"}' }

  describe '#thumbnail_url' do
    it 'returns a url for the thumbnail' do
      expect(document.thumbnail_url).to eq('http://example.com/thumb.jpg')
    end
  end
end
