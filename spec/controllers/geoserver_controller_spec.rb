require 'rails_helper'

describe GeoserverController, type: :controller do
  describe '#index' do
    it 'initiates a reverse proxy with headers' do
      allow(controller).to receive(:reverse_proxy)
      controller.index
      expect(controller).to have_received(:reverse_proxy).with(anything, hash_including(:headers))
    end
  end
end
