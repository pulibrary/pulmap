require 'rails_helper'

feature 'leaflet bbox overlay', js: true do
  scenario 'renders for restricted image works' do
    visit solr_document_path('princeton-3x816p22x')
    expect(page).to have_css('.leaflet-overlay-pane > svg')
  end
  scenario 'does not render in search results' do
    visit '/catalog?bbox=-180%20-30%20180%2075'
    expect(page).not_to have_css('.leaflet-overlay-pane > svg')
  end
end
