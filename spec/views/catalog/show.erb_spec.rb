require 'rails_helper'

describe 'catalog#show', type: :view do
  let(:solr_doc_id) { 'mit-us-ma-e25zcta5dct-2000' }

  context 'when a public dataset is rendered the tools sidebar' do
    it 'does not include carto label' do
      visit solr_document_path solr_doc_id.to_s
      expect(rendered).not_to have_content 'Open in Carto'
    end
    it 'does not include li tag exports class ' do
      visit solr_document_path solr_doc_id.to_s
      expect(rendered).not_to have_css '#tools-sidebar li.exports'
    end
  end
end
