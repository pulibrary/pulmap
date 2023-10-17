# frozen_string_literal: true

require "rails_helper"

describe PulmapGeoblacklightHelper, type: :helper do
  include GeoblacklightHelper

  describe "#viewer_container" do
    let(:document) { SolrDocument.new(document_attributes) }
    let(:references_field) { Settings.FIELDS.REFERENCES }
    let(:rights_field) { Settings.FIELDS.RIGHTS }

    context "with iiif manifest" do
      let(:manifest_viewer) { double }
      let(:document_attributes) do
        {
          references_field => {
            "http://iiif.io/api/image" => "https://example.edu/image/info.json",
            "http://iiif.io/api/presentation#manifest" => "https://example.edu/image/manifest.json"
          }.to_json
        }
      end

      it "renders a UV container" do
        assign(:document, document)
        allow(helper).to receive(:manifest_viewer)
        helper.viewer_container
        expect(helper).to have_received(:manifest_viewer)
      end
    end

    context "when missing iiif manifest" do
      let(:leaflet_viewer) { double }
      let(:document_attributes) do
        {
          references_field => {
            "http://iiif.io/api/image" => "https://example.edu/image/info.json"
          }.to_json
        }
      end

      it "renders a Leaflet container" do
        assign(:document, document)
        allow(helper).to receive(:leaflet_viewer)
        allow(helper).to receive(:geoblacklight_basemap)
        helper.viewer_container
        expect(helper).to have_received(:leaflet_viewer)
      end
    end

    context "with pmtiles layer" do
      let(:ol_viewer) { double }
      let(:document_attributes) do
        {
          references_field => {
            "https://github.com/protomaps/PMTiles" => "https://test-data.cloudgbl.org/tufts-cambridgegrid100-04.pmtiles"
          }.to_json
        }
      end

      it "renders an OpenLayers container" do
        allow(helper).to receive(:geoblacklight_basemap).and_return("esri")
        assign(:document, document)
        node = Capybara.string(helper.viewer_container)
        div = node.first("div")
        expect(div[:id]).to eq "ol-map"
      end
    end

    context "with an ArcGIS Tiled Map Layer" do
      let(:leaflet_viewer) { double }
      let(:document_attributes) do
        {
          references_field => {
            "urn:x-esri:serviceType:ArcGIS#TiledMapLayer" =>
              "https://example.edu/arcgis/rest/services/Specialty/Soil_Survey_Map/MapServer"
          }.to_json,
          rights_field => "Public"
        }
      end

      before do
        allow(helper).to receive(:geoblacklight_basemap).and_return("esri")
        assign(:document, document)
      end

      it "renders a Leaflet container with the fullscreen option" do
        node = Capybara.string(helper.viewer_container)
        div = node.first("div")
        expect(div[:'data-leaflet-options']).to include(
          '"TILEDMAPLAYER":{"CONTROLS":["Opacity","Fullscreen","Layers"]}'
        )
      end
    end

    context "with an ArcGIS Feature Layer" do
      let(:leaflet_viewer) { double }
      let(:document_attributes) do
        {
          references_field => {
            "urn:x-esri:serviceType:ArcGIS#FeatureLayer" =>
              "https://example.edu/arcgis/rest/services/Fire_Station_Areas/FeatureServer"
          }.to_json,
          rights_field => "Public"
        }
      end

      before do
        allow(helper).to receive(:geoblacklight_basemap).and_return("esri")
        assign(:document, document)
      end

      it "renders a Leaflet container with the fullscreen option" do
        node = Capybara.string(helper.viewer_container)
        div = node.first("div")
        expect(div[:'data-leaflet-options']).to include(
          '"FEATURELAYER":{"CONTROLS":["Opacity","Fullscreen","Layers"]}'
        )
      end
    end

    context "with an ArcGIS Dynamic Map Layer" do
      let(:leaflet_viewer) { double }
      let(:document_attributes) do
        {
          references_field => {
            "urn:x-esri:serviceType:ArcGIS#DynamicMapLayer" =>
              "https://example.edu/arcgis/rest/services/Geology/Glacial_Boundaries/MapServer"
          }.to_json,
          rights_field => "Public"
        }
      end

      before do
        allow(helper).to receive(:geoblacklight_basemap).and_return("esri")
        assign(:document, document)
      end

      it "renders a Leaflet container with the fullscreen option" do
        node = Capybara.string(helper.viewer_container)
        div = node.first("div")
        expect(div[:'data-leaflet-options']).to include(
          '"DYNAMICMAPLAYER":{"CONTROLS":["Opacity","Fullscreen","Layers"]}'
        )
      end
    end

    context "with an ArcGIS Image Map Layer" do
      let(:leaflet_viewer) { double }
      let(:document_attributes) do
        {
          references_field => {
            "urn:x-esri:serviceType:ArcGIS#ImageMapLayer" =>
              "https://example.edu/arcgis/rest/services/NAIP_2011/NAIP_2011_Dynamic/ImageServer"
          }.to_json,
          rights_field => "Public"
        }
      end

      before do
        allow(helper).to receive(:geoblacklight_basemap).and_return("esri")
        assign(:document, document)
      end

      it "renders a Leaflet container with the fullscreen option" do
        node = Capybara.string(helper.viewer_container)
        div = node.first("div")
        expect(div[:'data-leaflet-options']).to include(
          '"IMAGEMAPLAYER":{"CONTROLS":["Opacity","Fullscreen","Layers"]}'
        )
      end
    end
  end

  describe "#data_download_text" do
    it "generates the text for the download link element for original and generated files" do
      expect(helper.data_download_text("GeoTIFF")).to eq "Download GeoTIFF"
    end
  end
end
