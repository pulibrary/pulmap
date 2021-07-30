# frozen_string_literal: true

require 'rails_helper'

describe 'Show page' do
  context 'with a restricted Princeton scanned map' do
    it 'the login to view and download button is not displayed' do
      visit solr_document_path 'princeton-kk91fn37z'
      expect(page).not_to have_content 'Login to view and download'
    end
  end

  describe 'response to Blacklight::Exceptions::RecordNotFound exception' do
    it 'redirects to the 404 page' do
      visit solr_document_path 'princeton-kk91fn37znotfound'
      expect(page).to have_content "The page you were looking for doesn't exist.\nYou may have mistyped the address or"
      expect { page }.not_to raise_error
      expect(page.status_code).to eq 404
    end

    context 'with an invalid download link' do
      it 'redirects to the 404 page' do
        visit '/download/hgl/pul-logo-new.svg'
        expect(page).to have_content "The page you were looking for doesn't exist.\nYou may have mistyped the address or"
        expect { page }.not_to raise_error
        expect(page.status_code).to eq 404
      end
    end
  end
end
