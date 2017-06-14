require 'rails_helper'

feature 'leaflet bbox overlay', js: true do
  scenario 'renders for restricted image works' do
    visit solr_document_path('princeton-3x816p22x')
    expect(page).to have_css('.leaflet-overlay-pane > svg')
  end
end
