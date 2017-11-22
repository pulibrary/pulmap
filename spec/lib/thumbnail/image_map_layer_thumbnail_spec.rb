require 'rails_helper'

describe ImageMapLayerThumbnail do
  let(:document) { SolrDocument.new(document_attributes) }
  let(:document_attributes) { { layer_id_s: 'testlayer', dct_references_s: references } }

  describe '#thumbnail_url' do
    let(:image_map_layer_service_url) do
      'http://www.example.com/arcgis/rest/services/image/info/thumbnail/thumbnail.png'
    end
    let(:references) do
      {
        'urn:x-esri:serviceType:ArcGIS#ImageMapLayer' => 'http://www.example.com/arcgis/rest/services/image'
      }.to_json
    end

    it 'returns an image map layer service thumbnail url' do
      expect(described_class.thumbnail_url(document, 256)).to eq(image_map_layer_service_url)
    end
  end
end
