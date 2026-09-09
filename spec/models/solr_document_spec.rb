# frozen_string_literal: true

require "rails_helper"

describe Geoblacklight::SolrDocument do
  describe "#geoblacklight_citation" do
    context "when creating a citation for a Princeton record" do
      it "creates a generic citation" do
        document = SolrDocument.find("princeton-m613n013z")
        citation = document.geoblacklight_citation("http://example.com")
        expect(citation).not_to include "The Princeton University Library makes available"
        expect(citation).to include "Environmental Systems Research Institute, Inc. (ESRI)"
      end
    end
    context "when creating a citation for a non-Princeton record" do
      it "creates a generic citation" do
        document = SolrDocument.find("tufts-cambridgegrid100-04")
        citation = document.geoblacklight_citation("http://example.com")
        expect(citation).not_to include "The Princeton University Library makes available"
        expect(citation).to include "100 Foot Grid Cambridge MA 2004. [Shapefile]. Cambridge (Mass.)"
      end
    end
  end

  describe "#thumbnail_url" do
    context "when the document has a thumbnail reference" do
      it "returns the url" do
        document = SolrDocument.find("princeton-kk91fn37z")
        expect(document.thumbnail_url).to start_with "https://iiif-cloud.princeton.edu/iiif/2/"
        expect(document.thumbnail_reference?).to be true
      end
    end

    context "when the document has no thumbnail reference" do
      it "returns nil" do
        document = SolrDocument.find("princeton-fk4bk1p41f")
        expect(document.thumbnail_url).to be_nil
        expect(document.thumbnail_reference?).to be false
      end
    end
  end
end
