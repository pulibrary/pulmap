# frozen_string_literal: true

require "rails_helper"

describe "Show page downloads" do
  it "renders the the authentication link for access-restricted Princeton Documents" do
    visit solr_document_path("princeton-m613n013z")
    expect(page).to have_link "Login to view"
  end

  context "when the user logs in" do
    before do
      OmniAuth.config.test_mode = true
    end

    it "renders download links for access-restricted Princeton Documents" do
      visit solr_document_path("princeton-m613n013z")
      expect(page).not_to have_css ".download-link-container"
      find(".list-group-item.access > a").click # login to view link
      expect(page).to have_css ".download-link-container"
    end
  end

  it "renders a link to request offline access for Princeton Documents unavailable online" do
    visit solr_document_path("princeton-fk4bk1p41f")
    expect(page).to have_link "Request offline access"
  end

  it "renders the card containing the download links for non-Princeton Documents" do
    visit solr_document_path("stanford-cz128vq0535")
    expect(page).to have_link "Original Shapefile"
  end
end
