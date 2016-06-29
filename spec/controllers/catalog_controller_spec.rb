require 'rails_helper'

describe CatalogController do
  describe '#has_search_parameters?' do
    subject { controller.has_search_parameters? }
    describe 'empty q value' do
      before { allow(controller).to receive_messages(params: { q: nil }) }
      it { is_expected.to be false }
    end
  end
end
