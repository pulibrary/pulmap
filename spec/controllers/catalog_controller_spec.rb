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
  describe '#downloads' do
    context 'with a downloadable Princeton item' do
      it 'renders dowload page' do
        get :downloads, params: { id: 'princeton-m613n013z' }
        expect(response).to have_http_status(200)
        expect(assigns(:document)).not_to be_nil
      end
    end

    context 'with a downloadable non-Princeton item' do
      it 'redirects with a 404' do
        get :downloads, params: { id: 'nyu_2451_34548' }
        expect(response).to have_http_status(404)
      end
    end

    context 'with a non-downloadable Princeton item' do
      it 'redirects with a 404' do
        get :downloads, params: { id: 'princeton-02870w62c' }
        expect(response).to have_http_status(404)
      end
    end
  end
end
