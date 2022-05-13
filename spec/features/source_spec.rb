# frozen_string_literal: true

require "rails_helper"

describe "Princeton special collections provenance" do
  context "with a Princeton historic maps collection record" do
    it "renders a special provenance" do
      visit solr_document_path "princeton-1r66j405w"
      expect(page).to have_css ".blacklight-dct_provenance_s", text: "Princeton: Historic Map Division"
    end
  end

  context "with a Princeton non-historic maps collection record" do
    it "does not render the source card" do
      visit solr_document_path "princeton-02870w62c"
      expect(page).not_to have_css ".blacklight-dct_provenance_s", text: "Princeton: Historic Map Division"
    end
  end
end
