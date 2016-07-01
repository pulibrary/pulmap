require 'spec_helper'

feature 'Full screen control', js: true do
  scenario 'IIIF layer should have full screen control' do
    visit catalog_path('princeton-02870w62c')
    expect(page).to have_css('.leaflet-control-fullscreen-button')
  end
  scenario 'WMS layer should have full screen control' do
    visit catalog_path('mit-us-ma-e25zcta5dct-2000')
    expect(page).to have_css('.leaflet-control-fullscreen-button')
  end
end