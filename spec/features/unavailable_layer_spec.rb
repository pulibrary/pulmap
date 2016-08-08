require 'rails_helper'

feature 'Unavailable layer' do
  scenario 'hides and shows appropriate messages for geomonitored unavailable' do
    visit solr_document_path 'harvard-ntadcd106'
    expect(page).not_to have_content 'Download Shapefile'
  end
  scenario 'catalog index page should have availablility facets' do
    visit search_catalog_path q: '*'
    expect(page).to have_css '.facet_select', text: 'Unavailable'
    expect(page).to have_css '.facet_select', text: 'Available'
  end
end
