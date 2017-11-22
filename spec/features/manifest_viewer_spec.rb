require 'rails_helper'

describe 'IIIF Universal Viewer' do
  it 'renders for record that includes IIIF manifest from Plum' do
    visit solr_document_path('princeton-8c97ks94m')
    expect(page).to have_css('.view.uv')
  end

  it 'does not render record titles' do
    visit solr_document_path('princeton-8c97ks94m')
    expect(page).not_to have_css('#app .mainPanel .centerPanel > .title')
  end
end
