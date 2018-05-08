require 'rails_helper'

describe 'IIIF Universal Viewer' do
  it 'renders for record that includes IIIF manifest from Figgy' do
    visit solr_document_path('princeton-cv43nz62s')
    expect(page).to have_css('.view.uv')
  end

  it 'does not render record titles' do
    visit solr_document_path('princeton-cv43nz62s')
    expect(page).not_to have_css('#app .mainPanel .centerPanel > .title')
  end
end
