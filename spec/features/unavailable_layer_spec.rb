require 'rails_helper'

feature 'Unavailable layer' do
  scenario 'hides and shows appropriate messages for geomonitored unavailable' do
    visit catalog_path 'harvard-ntadcd106'
    expect(page).to_not have_content 'Download Shapefile'
  end
  scenario 'catalog index page should have availablility facets' do
    visit catalog_index_path q: '*'
    expect(page).to have_css '.facet_select', text: 'Unavailable'
    expect(page).to have_css '.facet_select', text: 'Available'
  end
end
