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

  describe '#render_constraint_element' do
    context 'when a bounding box constraint is applied' do
      let(:params) do
        { bbox: '-43.9453125 04.214943 043.9453125 036.597889' }
      end

      before do
        allow(controller).to receive(:params).and_return(params)
      end

      it 'does not render values for bounding box constraints' do
        expect(helper.render_constraint_element('Bounding Box',\
                                                '-43.9453125 04.214943 043.9453125 036.597889'))\
          .not_to have_content('-43.9453125 04.214943 043.9453125 036.597889')
      end

      it 'renders other constaints' do
        expect(helper.render_constraint_element('Data type', 'Polygon')).to have_content('Polygon')
      end
    end
  end
end
