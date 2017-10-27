require 'rails_helper'

feature 'Show page downloads' do
  scenario 'renders the the link to the download credit request page for Princeton Documents' do
    visit solr_document_path('princeton-8c97ks94m')
    expect(page).to have_css '#downloadsLink'
  end

  scenario 'renders the the authentication link for access-restricted Princeton Documents' do
    visit solr_document_path('princeton-3x816p22x')
    expect(page).to have_link 'Login to view and download'
  end

  scenario 'renders a link to request offline access for Princeton Documents unavailable online' do
    visit solr_document_path('princeton-fk4bk1p41f')
    expect(page).to have_link 'Request offline access'
  end

  scenario 'renders the panel containing the download links for non-Princeton Documents' do
    visit solr_document_path('stanford-cz128vq0535')
    expect(page).to have_link 'Download Shapefile'
  end
end
