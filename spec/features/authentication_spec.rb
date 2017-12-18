require 'rails_helper'

RSpec.describe 'Authentication', type: :feature do
  describe 'log out redirect' do
    let(:user) { FactoryBot.create(:user) }

    before do
      OmniAuth.config.test_mode = true
      visit solr_document_path 'columbia-columbia-landinfo-global-aet'
      sign_in(user)
    end
    it 'after logout, user returns to root page' do
      expect(page).to have_current_path(root_path)
    end
  end
end
