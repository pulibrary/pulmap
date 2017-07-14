require 'rails_helper'

feature 'Sanborn Map Legend' do
  scenario 'renders the panel containing the legend for Sanborn Maps' do
    visit solr_document_path('princeton-1r66j405w')
    expect(page).to have_css('.show-sanborn-legend')
  end
end
