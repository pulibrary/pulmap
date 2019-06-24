require 'rails_helper'

describe 'Show page source card' do
  context 'with a Princeton historic maps collection record' do
    it 'renders the source card' do
      visit solr_document_path 'princeton-1r66j405w'
      expect(page).to have_css '.card-header', text: 'Source'
    end
  end

  context 'with a Princeton non-historic maps collection record' do
    it 'does not render the source card' do
      visit solr_document_path 'princeton-02870w62c'
      expect(page).not_to have_css '.card-header', text: 'Source'
    end
  end
end
