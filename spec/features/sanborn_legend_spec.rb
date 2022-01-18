# frozen_string_literal: true

require 'rails_helper'

describe 'Sanborn Map Legend' do
  it 'renders the card containing the legend for Sanborn Maps' do
    visit solr_document_path('princeton-1r66j405w')
    expect(page).to have_css('#sanborn-legend')
  end

  it 'opens the modal containing the legend for Sanborn Maps', js: true do
    visit solr_document_path('princeton-1r66j405w')
    click_button('sanborn-legend-button')
    expect(page).to have_selector('#sanborn-legend-large', visible: true)
  end
end
