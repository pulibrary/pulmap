# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Retired URLs", type: :request do
  it "returns 410 Gone with active storage URLs" do
    get "/rails/active_storage/blobs/redirect/abc123/thumbnail.png"

    expect(response).to have_http_status(:gone)
  end

  it "does not block other routes" do
    get "/robots.txt"

    expect(response).not_to have_http_status(:gone)
  end
end
