require 'rails_helper'

describe 'Show page downloads' do
  it 'renders the the link to the download credit request page for Princeton Documents' do
    visit solr_document_path('princeton-cv43nz62s')
    expect(page).to have_css '#downloadsLink'
  end

  it 'renders the the authentication link for access-restricted Princeton Documents' do
    visit solr_document_path('princeton-m613n013z')
    expect(page).to have_link 'Login to view and download'
  end

  it 'renders a link to request offline access for Princeton Documents unavailable online' do
    visit solr_document_path('princeton-fk4bk1p41f')
    expect(page).to have_link 'Request offline access'
  end

  it 'renders the card containing the download links for non-Princeton Documents' do
    visit solr_document_path('stanford-cz128vq0535')
    expect(page).to have_link 'Original Shapefile'
  end

  it 'does not render the download link for public Princeton scanned maps without tiff download' do
    visit solr_document_path('princeton-1r66j405w')
    expect(page).not_to have_css '#downloadsLink'
  end
end
