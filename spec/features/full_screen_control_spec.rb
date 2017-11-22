require 'spec_helper'

describe 'Full screen control', js: true do
  it 'IIIF layer should have full screen control' do
    visit solr_document_path('princeton-02870w62c')
    expect(page).to have_css('.leaflet-control-fullscreen-button')
  end
  it 'WMS layer should have full screen control' do
    visit solr_document_path('mit-us-ma-e25zcta5dct-2000')
    expect(page).to have_css('.leaflet-control-fullscreen-button')
  end
end
