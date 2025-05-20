# frozen_string_literal: true

require "rails_helper"

describe "Show page" do
  context "with a restricted Princeton scanned map" do
    it "the login to view and download button is not displayed" do
      visit solr_document_path "princeton-kk91fn37z"
      expect(page).not_to have_content "Login to view and download"
    end
  end

  describe "response to Blacklight::Exceptions::RecordNotFound exception" do
    it "redirects to the 404 page" do
      visit solr_document_path "princeton-kk91fn37znotfound"
      expect(page).to have_content "The page you were looking for doesn't exist.\nYou may have mistyped the address or"
      expect { page }.not_to raise_error
      expect(page.status_code).to eq 404
    end

    context "with an invalid download link" do
      it "redirects to the 404 page" do
        visit "/download/hgl/pul-logo-new.svg"
        expect(page).to have_content "The page you were looking for doesn't exist.\nYou may have mistyped the address or"
        expect { page }.not_to raise_error
        expect(page.status_code).to eq 404
      end
    end
  end

  describe "web services modal" do
    it "renders wms / wfs links" do
      visit solr_document_path "stanford-cz128vq0535"
      click_link "Web services"
      within ".modal-body" do
        expect(page).to have_css "label", text: "Web Feature Service (WFS)"
        expect(page).to have_css 'input[value="https://geowebservices.stanford.edu/geoserver/wfs"]'
        expect(page).to have_css 'input[value="druid:cz128vq0535"]', count: 2
        expect(page).to have_css "label", text: "Web Mapping Service (WMS)"
        expect(page).to have_css 'input[value="https://geowebservices.stanford.edu/geoserver/wms"]'
      end
    end
  end
end
