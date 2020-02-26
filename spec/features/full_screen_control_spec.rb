# frozen_string_literal: true

require 'spec_helper'

describe 'Full screen control', js: true do
  it 'IIIF layer should have full screen control' do
    visit solr_document_path('princeton-02870w62c')
    expect(page).to have_css('.leaflet-control-fullscreen-button')
  end
  it 'WMS layer should have full screen control' do
    visit solr_document_path('stanford-cz128vq0535')
    expect(page).to have_css('.leaflet-control-fullscreen-button')
  end
end
