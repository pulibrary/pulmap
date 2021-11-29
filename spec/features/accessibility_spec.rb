# frozen_string_literal: true

require 'rails_helper'

describe "accessibility", type: :feature, js: true do
  context "when visiting main page" do
    it "complies with WCAG" do
      visit root_path

      expect(page).to be_axe_clean
        .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
        .excluding(".tt-hint") # Issue is in typeahead.js library
        .skipping("color-contrast") # See issue: #1000
        .skipping("button-name") # See issue: #1001
        .skipping("link-name") # See issue: #1002
    end
  end

  context "when visiting record show page" do
    it "complies with WCAG" do
      visit solr_document_path 'princeton-kk91fn37z'

      expect(page).to be_axe_clean
        .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
        .excluding(".tt-hint") # Issue is in typeahead.js library
        .skipping("link-name") # See issue: #992
    end
  end
end
