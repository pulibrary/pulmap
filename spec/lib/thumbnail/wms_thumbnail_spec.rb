require 'rails_helper'

describe WmsThumbnail do
  let(:document) { SolrDocument.new(document_attributes) }
  let(:document_attributes) { { layer_id_s: 'testlayer', dct_references_s: references } }

  describe '#thumbnail_url' do
    let(:wms_service_url) do
      'http://www.example.com/wms/reflect?&FORMAT=image%2Fpng&'\
                            'TRANSPARENT=TRUE&LAYERS=testlayer&WIDTH=256&HEIGHT=256'
    end
    let(:references) do
      {
        'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://www.example.com/wms'
      }.to_json
    end

    it 'returns a web map service thumbnail url' do
      expect(described_class.thumbnail_url(document, 256)).to eq(wms_service_url)
    end
  end
end
