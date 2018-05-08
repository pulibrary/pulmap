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
    it 'download page renders' do
      get :downloads, params: { id: 'princeton-kk91fn37z' }
      expect(response).to have_http_status(200)
      expect(assigns(:document)).not_to be_nil
    end
  end
end
