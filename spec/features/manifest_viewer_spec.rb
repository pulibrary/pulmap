require 'rails_helper'

feature 'IIIF Universal Viewer' do
  scenario 'renders for record that includes IIIF manifest from Plum' do
    visit solr_document_path('princeton-8c97ks94m')
    expect(page).to have_css('#view')
  end
end
