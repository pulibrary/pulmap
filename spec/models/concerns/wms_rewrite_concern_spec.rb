require 'rails_helper'

describe WmsRewriteConcern do
  let(:document) { SolrDocument.new(document_attributes) }
  describe '#viewer_endpoint' do
    context 'when princeton and restricted' do
      let(:document_attributes) do
        {
          dct_provenance_s: 'Princeton',
          dc_rights_s: 'Restricted',
          dct_references_s: {
            'http://www.opengis.net/def/serviceType/ogc/wms' => 'https://geoserver.princeton.edu/restricted/geoserver/wms'
          }.to_json
        }
      end
      it 'rewrites url' do
        expect(document.viewer_endpoint).to eq 'http://localhost:3000/restricted/geoserver/wms'
      end
    end
    context 'when not princeton or public' do
      let(:document_attributes) do
        {
          dct_provenance_s: 'Stanford',
          dc_rights_s: 'Restricted',
          dct_references_s: {
            'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://www.example.com/geoserver/wms'
          }.to_json
        }
      end
      it 'does not rewrite url' do
        expect(document.viewer_endpoint).to eq 'http://www.example.com/geoserver/wms'
      end
    end
  end
  describe 'princeton_restricted?' do
    context 'when princeton and restricted' do
      let(:document_attributes) { { dct_provenance_s: 'Princeton', dc_rights_s: 'Restricted' } }
      it 'identifies restricted princeton documents' do
        expect(document.princeton_restricted?).to be_truthy
      end
    end
    context 'when princeton and public' do
      let(:document_attributes) { { dct_provenance_s: 'Princeton', dc_rights_s: 'Public' } }
      it 'requires both conditions' do
        expect(document.princeton_restricted?).to be_falsey
      end
    end
  end
  describe 'princeton?' do
    context 'when princeton' do
      let(:document_attributes) { { dct_provenance_s: 'Princeton' } }
      it 'identifies princeton documents' do
        expect(document.princeton?).to be_truthy
      end
    end
    context 'when non-princeton' do
      let(:document_attributes) { { dct_provenance_s: 'Stanford' } }
      it 'identifies princeton documents' do
        expect(document.princeton?).to be_falsey
      end
    end
  end
  describe '#thumbnail_generator_endpoint' do
    let(:document_attributes) do
      {
        dct_provenance_s: 'Princeton',
        dc_rights_s: 'Restricted',
        dct_references_s: {
          'http://www.opengis.net/def/serviceType/ogc/wms' => 'https://geoserver.princeton.edu/restricted/geoserver/wms'
        }.to_json
      }
    end
    it 'returns the original un-rewritten url' do
      expect(document.thumbnail_generator_endpoint).to eq 'https://geoserver.princeton.edu/restricted/geoserver/wms'
    end
  end
end
