require 'rails_helper'

describe 'Show page source panel' do
  context 'with a Princeton historic maps collection record' do
    it 'renders the source panel' do
      visit solr_document_path 'princeton-1r66j405w'
      expect(page).to have_css '.panel-heading', text: 'Source'
    end
  end

  context 'with a Princeton non-historic maps collection record' do
    it 'does not render the source panel' do
      visit solr_document_path 'princeton-02870w62c'
      expect(page).not_to have_css '.panel-heading', text: 'Source'
    end
  end
end
