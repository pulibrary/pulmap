# frozen_string_literal: true
require 'rails_helper'

describe CatalogController, type: :controller do
  describe '#has_search_parameters?' do
    subject { controller.has_search_parameters? }

    describe 'empty q value' do
      before { allow(controller).to receive_messages(params: { q: nil }) }
      it { is_expected.to be false }
    end
  end

  describe 'ActiveStorage error handling' do
    before do
      allow(controller).to receive(:index).and_raise ActiveSupport::MessageVerifier::InvalidSignature
    end

    it 'does not raise error' do
      get :index
      expect { response }.not_to raise_error
      expect(response).to have_http_status(404)
    end
  end
end
