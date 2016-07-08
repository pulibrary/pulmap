require 'rails_helper'

describe SolrDocument do
  let(:document) { described_class.new(document_attributes) }
  let(:document_attributes) { { dct_references_s: refs } }
  let(:refs) { '{"http://schema.org/thumbnailUrl":"http://example.com/thumb.jpg"}' }

  before do
    allow(Settings.THUMBNAIL).to receive(:USE_DCT_REFS).and_return(true)
  end
  describe '#thumbnail_url' do
    it 'returns a url for the thumbnail' do
      expect(document.thumbnail_url).to eq('http://example.com/thumb.jpg')
    end
  end
end
