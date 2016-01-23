require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  describe 'log in and out redirect' do
    let(:user) { FactoryGirl.create(:user) }

    before do
      OmniAuth.config.test_mode = true
      referer = catalog_path 'columbia-columbia-landinfo-global-aet'
      Capybara.current_session.driver.header 'Referer', referer
      sign_in(user)
    end
    scenario 'after login, user returns to last visited page' do
      expect(page).to have_css '.blacklight-catalog-show', count: 1
    end
    scenario 'after logout, user returns to last visited page' do
      visit '/users/sign_out'
      expect(page).to have_css '.blacklight-catalog-show', count: 1
    end
  end
end
