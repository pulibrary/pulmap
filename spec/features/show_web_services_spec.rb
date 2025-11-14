# frozen_string_literal: true

require "rails_helper"

describe "Show page web services" do
  it "does not render the the web services link for access-restricted Princeton Documents" do
    visit solr_document_path("princeton-m613n013z")
    expect(page).not_to have_link "Web services"
  end

  context "when the user logs in" do
    before do
      OmniAuth.config.test_mode = true
    end

    it "does  render the the web services link for access-restricted Princeton Documents" do
      visit solr_document_path("princeton-m613n013z")
      click_link "Login"
      expect(page).to have_link "Web services"
    end
  end
end
