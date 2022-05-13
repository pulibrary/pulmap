# frozen_string_literal: true

require "rails_helper"

describe "accessibility", type: :feature, js: true do
  context "when visiting main page" do
    it "complies with WCAG" do
      visit root_path

      expect(page).to be_axe_clean
        .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
        .excluding(".tt-hint") # Issue is in typeahead.js library
        .excluding(".grid-item") # See issue: #1085
        .skipping("link-name") # See issue: #1012
    end
  end

  context "when visiting search results page" do
    it "complies with WCAG" do
      visit "/?f[dc_source_sm][]=princeton-1r66j405w&q="

      expect(page).to be_axe_clean
        .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
        .excluding(".tt-hint") # Issue is in typeahead.js library
        .skipping("nested-interactive") # See issue: #1004
        .skipping("link-name") # See issue: #1012
    end
  end

  context "when visiting record show page" do
    it "complies with WCAG" do
      visit solr_document_path "princeton-kk91fn37z"

      expect(page).to be_axe_clean
        .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
        .excluding(".tt-hint") # Issue is in typeahead.js library
    end
  end
end
