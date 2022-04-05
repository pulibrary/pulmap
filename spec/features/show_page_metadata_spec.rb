# frozen_string_literal: true

require 'rails_helper'

describe 'Metadata display on show page' do
  context 'with a public scanned map record' do
    it 'renders default metadata' do
      visit solr_document_path 'princeton-02870w62c'
      expect(page).to have_css '.blacklight-dc_creator_sm', text: 'Author(s):'
      expect(page).to have_css '.blacklight-dc_publisher_s', text: 'Publisher:'
      expect(page).to have_css '.blacklight-dc_rights_s', text: 'Access:'
      expect(page).to have_css '.blacklight-dc_description_s', text: 'Description:'
      expect(page).to have_css '.blacklight-dct_spatial_sm', text: 'Place(s):'
      expect(page).to have_css '.blacklight-dc_subject_sm', text: 'Subject(s):'
      expect(page).to have_css '.blacklight-dct_temporal_sm', text: 'Year:'
      expect(page).to have_css '.blacklight-call_number_s', text: 'Call number:'
      expect(page).to have_css '.blacklight-dct_provenance_s', text: 'Held by:'
      expect(page).not_to have_content 'Thumbnail:'

      # Rights statement
      expect(page).to have_css '.blacklight-rights_statement_s', text: 'Rights Statement:'
      expect(page).to have_link 'No Known Copyright', href: 'http://rightsstatements.org/vocab/NKC/1.0/'
    end
  end

  context 'with a restricted scanned map record with a thumbnail url' do
    it 'renders a thumbnail' do
      visit solr_document_path 'princeton-kk91fn37z'
      expect(page).to have_content 'Thumbnail:'
    end
  end

  context 'with a restricted scanned map record without a thumbnail url' do
    it 'does not render a thumbnail' do
      visit solr_document_path 'princeton-fk4bk1p41f'
      expect(page).not_to have_content 'Thumbnail:'
    end
  end
end
