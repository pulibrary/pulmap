require 'rails_helper'

describe PulmapGeoblacklightHelper, type: :helper do
  include GeoblacklightHelper

  describe '#viewer_container' do
    let(:document) { SolrDocument.new(document_attributes) }
    let(:references_field) { Settings.FIELDS.REFERENCES }
    context 'with iiif manifest' do
      let(:manifest_viewer) { double }
      let(:document_attributes) do
        {
          references_field => {
            'http://iiif.io/api/image' => 'https://example.edu/image/info.json',
            'http://iiif.io/api/presentation#manifest' => 'https://example.edu/image/manifest.json'
          }.to_json
        }
      end
      it 'renders a UV container' do
        assign(:document, document)
        expect(helper).to receive(:manifest_viewer)
        helper.viewer_container
      end
    end
    context 'missing iiif manifest' do
      let(:leaflet_viewer) { double }
      let(:document_attributes) do
        {
          references_field => {
            'http://iiif.io/api/image' => 'https://example.edu/image/info.json'
          }.to_json
        }
      end
      it 'renders a Leaflet container' do
        assign(:document, document)
        expect(helper).to receive(:leaflet_viewer)
        helper.viewer_container
      end
    end
  end
end
