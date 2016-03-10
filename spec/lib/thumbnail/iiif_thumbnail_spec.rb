require 'rails_helper'

describe IiifThumbnail do
  let(:document) { SolrDocument.new(document_attributes) }
  let(:document_attributes) { { dct_references_s: references } }

  describe '#thumbnail_url' do
    let(:iiif_service_url) { 'http://www.example.com/iiif/testlayer/full/256,/0/default.png' }
    let(:references) do
      {
        'http://iiif.io/api/image' => 'http://www.example.com/iiif/testlayer/info.json'
      }.to_json
    end

    it 'returns a iiif thumbnail url' do
      expect(described_class.thumbnail_url(document, 256)).to eq(iiif_service_url)
    end
  end
end
