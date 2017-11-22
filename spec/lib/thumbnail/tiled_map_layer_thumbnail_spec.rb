require 'rails_helper'

describe TiledMapLayerThumbnail do
  let(:document) { SolrDocument.new(document_attributes) }
  let(:document_attributes) { { layer_id_s: 'testlayer', dct_references_s: references } }

  describe '#thumbnail_url' do
    let(:tiled_map_layer_service_url) do
      'http://www.example.com/arcgis/rest/services/tiled/info/thumbnail/thumbnail.png'
    end
    let(:references) do
      {
        'urn:x-esri:serviceType:ArcGIS#TiledMapLayer' => 'http://www.example.com/arcgis/rest/services/tiled'
      }.to_json
    end

    it 'returns a tiled map layer service thumbnail url' do
      expect(described_class.thumbnail_url(document, 256)).to eq(tiled_map_layer_service_url)
    end
  end
end
