# frozen_string_literal: true

require 'rails_helper'

describe 'Show page' do
  context 'with a restricted Princeton scanned map' do
    it 'the login to view and download button is not displayed' do
      visit solr_document_path 'princeton-kk91fn37z'
      expect(page).not_to have_content 'Login to view and download'
    end
  end
end
