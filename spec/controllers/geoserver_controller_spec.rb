require 'rails_helper'

describe GeoserverController, type: :controller do
  describe '#index' do
    it 'initiates a reverse proxy with headers' do
      expect(controller).to receive(:reverse_proxy).with(anything, hash_including(:headers))
      controller.index
    end
  end
end
