require 'spec_helper'

describe ThumbnailHelper, type: :helper do
  include Geoblacklight::GeoblacklightHelperBehavior

  let(:document) { SolrDocument.new(document_attributes) }
  let(:document_attributes) { { solr_geom: 'ENVELOPE(-180, 180, 90, -90)', dct_references_s: references, dc_rights_s: 'public' } }
  describe '#gbl_thumbnail_url' do
    context 'dct_references with thumbnail ref only' do
      let(:references) do
        {
          'http://schema.org/thumbnailUrl' => 'http://www.example.com/image.jpg'
        }.to_json
      end
      it 'returns thumbnail ref url' do
        allow(document).to receive('checked_endpoint').with('thumb').and_return('http://www.example.com/image.jpg')
        expect(gbl_thumbnail_url(document)).to eq 'http://www.example.com/image.jpg'
      end
    end
    context 'dct_references with thumbnail ref and wms ref' do
      let(:references) do
        {
          'http://schema.org/thumbnailUrl' => 'http://www.example.com/image.jpg',
          'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://www.geoserver.com/layer/wms'
        }.to_json
      end
      it 'returns thumbnail ref ref url when there are viewer endoints' do
        allow(document).to receive('checked_endpoint').with('thumb').and_return('http://www.example.com/image.jpg')
        allow(document).to receive('checked_endpoint').with('wms').and_return('http://www.geoserver.com/layer/wms')
        expect(gbl_thumbnail_url(document)).to eq 'http://www.example.com/image.jpg'
      end
    end
    context 'no thumbnail ref in dct references' do
      let(:references) do
        {
          'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://www.geoserver.com/wms/layer'
        }.to_json
      end
      it 'returns thumbnail url from wms endpoint' do
        allow(self).to receive(:wxs_identifier). with(document).and_return('test_layer')
        allow(document).to receive('checked_endpoint').with('thumb').and_return(nil)
        allow(document).to receive('checked_endpoint').with('wms').and_return('http://www.geoserver.com/layer/wms')
        expect(gbl_thumbnail_url(document)).to eq 'http://www.geoserver.com/wms/layer?SERVICE=WMS&VERSION=1.1.1' \
                                                  '&REQUEST=GetMap&FORMAT=image%2Fpng&TRANSPARENT=TRUE&LAYERS=' \
                                                  '&WIDTH=100&HEIGHT=100&BBOX=-180,-90,180,90'
      end
    end
    context 'dct_references with no thumbnail ref and iiif ref' do
      let(:references) do
        {
          'http://iiif.io/api/image' => 'http://wwwexample.com/loris/image.jp2/info.json'
        }.to_json
      end
      it 'returns thumbnail url from iiif endpoint' do
        allow(document).to receive('checked_endpoint').with('iiif').and_return('http://wwwexample.com/loris/image.jp2/info.json')
        expect(gbl_thumbnail_url(document)).to eq 'http://wwwexample.com/loris/image.jp2/full/100,/0/default.jpg'
      end
    end
  end
end
