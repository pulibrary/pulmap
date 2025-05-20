# frozen_string_literal: true

require "rails_helper"

describe ApplicationHelper, type: :helper do
  include Geoblacklight::ViewHelperOverride

  describe "#layout_type" do
    it "returns index when on search results page" do
      allow(self).to receive(:params)
        .and_return(controller: "catalog", q: "roads", action: "index")
      expect(layout_type).to eq "index"
    end
    it "returns item when on show page" do
      allow(self).to receive(:params)
        .and_return(controller: "catalog", action: "show")
      expect(layout_type).to eq "item"
    end
    it "returns default when on search history page" do
      allow(self).to receive(:params).and_return(controller: "search_history")
      expect(layout_type).to eq "default"
    end
    it "returns default when on bookmarks page" do
      allow(self).to receive(:params).and_return(controller: "bookmarks")
      expect(layout_type).to eq "default"
    end
    it "returns default when on saved searches page" do
      allow(self).to receive(:params).and_return(controller: "saved_searches")
      expect(layout_type).to eq "default"
    end
  end
  describe "#item_layout?" do
    it "returns true when on show page" do
      allow(self).to receive(:params)
        .and_return(controller: "catalog", action: "show")
      expect(item_layout?).to be true
    end
    it "returns false when on search history page" do
      allow(self).to receive(:params).and_return(controller: "search_history")
      expect(item_layout?).to be false
    end
  end
  describe "#default_layout?" do
    it "returns true when on search_history page" do
      allow(self).to receive(:params).and_return(controller: "search_history")
      expect(default_layout?).to be true
    end
    it "returns true when on bookmarks page" do
      allow(self).to receive(:params).and_return(controller: "bookmarks")
      expect(default_layout?).to be true
    end
    it "returns true when on saved searches page" do
      allow(self).to receive(:params).and_return(controller: "saved_searches")
      expect(default_layout?).to be true
    end
  end
  describe "#placeholder_thumbnail_icon" do
    # This is necessary given the helper methods
    # These are only available within within the context of the ApplicationHelper
    define_method :url_for_document do |_doc|
      "http://localhost/catalog/test"
    end
    define_method :document_link_params do |_doc, _options|
      {}
    end
    context "when the name is blank" do
      it "doesn't error" do
        output = nil
        expect { output = placeholder_thumbnail_icon(nil, SolrDocument.new) }.not_to raise_error
        expect(output).to include '<a href="http://localhost/catalog/test">'
        expect(output).to include "<svg"
        expect(output).to include "</svg>"
      end
    end
    context 'when the document generates an icon with the name "vector"' do
      let(:document) { SolrDocument.new }
      let(:output) { placeholder_thumbnail_icon("vector", document) }

      it 'generates the "polygon" icon' do
        expect(output).to include '<a href="http://localhost/catalog/test">'
        expect(output).to include "<svg"
        expect(output).to include "Polygon"
        expect(output).to include "</svg>"
      end
    end
  end
  describe "#link_back_to_catalog_safe" do
    define_method :link_back_to_catalog do |_|
      "http://localhost/catalog"
    end

    it "returns a link to the search page" do
      expect(link_back_to_catalog_safe).to eq "http://localhost/catalog"
    end

    context "when there is an error" do
      define_method :link_back_to_catalog do |_doc|
        raise ActionController::UrlGenerationError, "Error"
      end

      it "returns a default link to the search page" do
        expect(link_back_to_catalog_safe).to include "Back to search"
      end
    end
  end
end
