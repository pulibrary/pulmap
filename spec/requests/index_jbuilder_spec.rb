# frozen_string_literal: true

require "rails_helper"

describe "index jbuilder", type: :request do
  describe "returned attributes" do
    it "matches search against title index" do
      get "/catalog.json?q=Carte+geologique+de+la+France"
      r = JSON.parse(response.body)
      attributes = r["data"].first["attributes"].keys
      expect(attributes).to include Settings.FIELDS.DESCRIPTION,
                                    Settings.FIELDS.TITLE,
                                    Settings.FIELDS.FILE_FORMAT,
                                    Settings.FIELDS.PUBLISHER,
                                    "layer_slug_s"
    end
  end
end
