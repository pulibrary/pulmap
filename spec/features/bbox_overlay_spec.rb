require 'rails_helper'

describe 'leaflet bbox overlay', js: true do
  it 'renders for restricted image works' do
    visit solr_document_path('princeton-3x816p22x')
    expect(page).to have_css('.leaflet-overlay-pane > svg')
  end
  it 'does not render in search results' do
    visit '/catalog?bbox=-180%20-30%20180%2075'
    page.reset!
    expect(page).not_to have_css('.leaflet-overlay-pane > svg')
  end
end
