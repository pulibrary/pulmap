# frozen_string_literal: true

require "rails_helper"

describe "proxy" do
  it "proxy requires authentication" do
    visit "/proxy/geodata/files/restricted/vermont.pmtiles"
    expect(page.status_code).to eq 401
  end
end
