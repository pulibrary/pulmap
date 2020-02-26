# frozen_string_literal: true

require 'rails_helper'

describe 'catalog/_web_services.html.erb', type: :view do
  before do
    assign(:documents, [document])
    render
  end

  context 'when the resource links to web service resources' do
    let(:wms_reference) { Geoblacklight::Reference.new(["http://www.opengis.net/def/serviceType/ogc/wms", "http://geoserver01.uit.tufts.edu/wms"]) }
    let(:wfs_reference) { Geoblacklight::Reference.new(["http://www.opengis.net/def/serviceType/ogc/wfs", "http://geoserver01.uit.tufts.edu/wfs"]) }
    let(:references) { instance_double(Geoblacklight::References, refs: [wms_reference, wfs_reference]) }
    let(:document) { instance_double(SolrDocument, references: references, wxs_identifier: 'sde:GISPORTAL.GISOWNER01.CAMBRIDGEGRID100_04') }

    it 'links to each reference' do
      expect(rendered).to have_css '#wms_webservice[value="http://geoserver01.uit.tufts.edu/wms"]'
      expect(rendered).to have_css '#wfs_webservice[value="http://geoserver01.uit.tufts.edu/wfs"]'
    end
  end

  context 'when the document cannot be resolved' do
    let(:document) { nil }

    it 'does not iterate through the references' do
      expect(rendered).not_to have_css '#wms_webservice[value="http://geoserver01.uit.tufts.edu/wms"]'
      expect(rendered).not_to have_css '#wfs_webservice[value="http://geoserver01.uit.tufts.edu/wfs"]'
    end
  end
end
