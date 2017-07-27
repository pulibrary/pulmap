require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  describe 'log out redirect' do
    let(:user) { FactoryGirl.create(:user) }

    before do
      OmniAuth.config.test_mode = true
      visit solr_document_path 'columbia-columbia-landinfo-global-aet'
      sign_in(user)
    end
    scenario 'after logout, user returns to root page' do
      expect(current_path).to eq root_path
    end
  end
end
