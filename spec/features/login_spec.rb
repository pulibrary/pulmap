# frozen_string_literal: true

require "rails_helper"

RSpec.describe "login workflow", type: :feature do
  before do
    OmniAuth.config.test_mode = true
  end
  # The return cookie gets lost if we don't set app_host for some reason?
  around do |example|
    old_host = Capybara.app_host
    Capybara.app_host = "http://localhost:3000"
    example.call
    Capybara.app_host = old_host
  end
  context "when logging in after being denied" do
    before do
      OmniAuth.config.mock_auth[:openid_connect] = OmniAuth::AuthHash.new(
        {
          "provider" => :openid_connect,
          "uid" => "admin123@princeton.edu",
          "info" => {},
          "credentials" => {
            "id_token" => "secret",
            "token" => "secret",
            "refresh_token" => nil,
            "expires_in" => 4489,
            "scope" => "email openid profile"
          },
          "extra" => {
            "raw_info" => {
              "sub" => "",
              "preferred_username" => "test@princeton.edu"
            }
          }
        })
    end
    it "returns the user to that path" do
      path = solr_document_path "nyu-2451-34564"
      visit path
      click_link "Login"
      expect(page).to have_link "Log Out"
      expect(page).to have_content("2014 New York City Places")
      expect(page.current_path).to eq path
      click_link "Log Out"
      expect(page).to have_current_path(root_path)
    end
  end
end
