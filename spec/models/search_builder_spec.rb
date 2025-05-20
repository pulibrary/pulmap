# frozen_string_literal: true

require "rails_helper"

describe SearchBuilder do
  subject(:builder) { search_builder.with(user_params) }

  let(:user_params) { {} }
  let(:solr_params) { {} }
  let(:context) { CatalogController.new }
  let(:search_builder) { described_class.new(context) }

  describe "#add_featured_content" do
    it "returns search for sanborn records when featured param is set to sanborn" do
      params = { featured: "sanborn" }
      builder.with(params)
      expect(builder.add_featured_content(solr_params)[:fq].to_s).to include("dc_title_s:*Sanborn")
    end

    it "returns search for scanned maps when featured param is set to scanned_maps" do
      params = { featured: "scanned_maps" }
      builder.with(params)
      expect(builder.add_featured_content(solr_params)[:fq].to_s).to include("-dc_title_s:*Sanborn")
    end

    it "returns search for vector and raster datasets when featured param is set to geospatial" do
      params = { featured: "geospatial" }
      builder.with(params)
      expect(builder.add_featured_content(solr_params)[:fq].to_s).to include("Polygon")
      expect(builder.add_featured_content(solr_params)[:fq].to_s).to include("Raster")
    end
  end
end
