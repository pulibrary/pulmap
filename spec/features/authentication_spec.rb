# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication', type: :feature do
  describe 'login page and log out redirect' do
    let(:user) { FactoryBot.create(:user) }
    let(:path) { solr_document_path 'nyu-2451-34564' }

    before do
      OmniAuth.config.test_mode = true
    end
    it 'stays on current page when logging in and redirects to root when logging out' do
      visit path
      click_link 'Login'
      expect(page).to have_current_path(path)
      click_link 'Log Out'
      expect(page).to have_current_path(root_path)
    end
  end
end
