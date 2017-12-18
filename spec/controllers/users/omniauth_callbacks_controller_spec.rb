require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController do
  describe 'log in redirect' do
    let(:user) { FactoryBot.create(:user) }

    it 'after login, user returns to origin page' do
      request.env['omniauth.origin'] = solr_document_path 'columbia-columbia-landinfo-global-aet'
      request.env['devise.mapping'] = Devise.mappings[:user]
      allow(User).to receive(:from_omniauth) { user }
      get :cas
      expect(response).to redirect_to(solr_document_path('columbia-columbia-landinfo-global-aet'))
    end
  end
end
