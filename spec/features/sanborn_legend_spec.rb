require 'rails_helper'

describe 'Sanborn Map Legend' do
  it 'renders the card containing the legend for Sanborn Maps' do
    visit solr_document_path('princeton-1r66j405w')
    expect(page).to have_css('.show-sanborn-legend')
  end
end
