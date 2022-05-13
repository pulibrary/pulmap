# frozen_string_literal: true

require "rails_helper"

describe GeomonitorConcern do
  let(:document) { SolrDocument.new(document_attributes) }

  describe "available?" do
    describe "for Princeton resources" do
      let(:document_attributes) do
        {
          dct_provenance_s: "Princeton",
          dc_rights_s: "Restricted"
        }
      end

      it "calls super logic" do
        expect(document).to be_available
      end
    end
    describe "for resources less than threshold tolerance" do
      let(:document_attributes) do
        {
          dct_provenance_s: "Harvard",
          dc_rights_s: "Restricted",
          layer_availability_score_f: 0.6
        }
      end

      it "is not avilable" do
        expect(document).not_to be_available
      end
    end
  end
  describe "score_meets_threshold?" do
    let(:document_attributes) { {} }

    it "no score present" do
      expect(document).to be_score_meets_threshold
    end
  end
end
