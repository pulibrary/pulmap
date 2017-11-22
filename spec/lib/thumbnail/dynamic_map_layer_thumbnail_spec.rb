require 'rails_helper'

describe DynamicMapLayerThumbnail do
  let(:document) { SolrDocument.new(document_attributes) }
  let(:document_attributes) { { layer_id_s: 'testlayer', dct_references_s: references } }

  describe '#thumbnail_url' do
    let(:dynamic_map_layer_service_url) do
      'http://www.example.com/arcgis/rest/services/dynamic/info/thumbnail/thumbnail.png'
    end
    let(:references) do
      {
        'urn:x-esri:serviceType:ArcGIS#DynamicMapLayer' => 'http://www.example.com/arcgis/rest/services/dynamic'
      }.to_json
    end

    it 'returns a dynamic map layer service thumbnail url' do
      expect(described_class.thumbnail_url(document, 256)).to eq(dynamic_map_layer_service_url)
    end
  end
end
