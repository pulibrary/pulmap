# frozen_string_literal: true

require 'rails_helper'

describe 'Geoserver requests', type: :request do
  describe '#index' do
    let(:query) { "service=WMS&request=GetMap&layers=restricted-figgy%3Ap-735d9ddb-d293-4454-b85b-e4d972f0708a&styles=&format=image%2Fpng&transparent=true&version=1.1.1&tiled=true&CRS=EPSG%3A900913&width=512&height=512&srs=EPSG%3A3857&bbox=-9705668.103538541,3443946.746416902,-9392582.03568246,3757032.8142729844" }
    let(:proxied_response) { instance_double(Faraday::Response) }
    let(:user) { FactoryBot.create(:user) }

    before do
      sign_in user
      allow(Faraday).to receive(:get).and_return(proxied_response)
    end

    it 'proxies GET requests to the GeoServer installation' do
      allow(proxied_response).to receive(:status).and_return(200)
      allow(proxied_response).to receive(:body).and_return("data")
      allow(proxied_response).to receive(:[]).with('Content-Type').and_return("application/octet-stream")

      get "/geoserver/restricted-figgy/wms?#{query}"

      expect(response).to be_success
      expect(response.body).not_to be_empty
    end

    context "when the response redirects the client" do
      before do
        allow(proxied_response).to receive(:status).and_return(301)
        allow(proxied_response).to receive(:[]).with('Location').and_return("https://geoserver.institution.edu/geoserver")
      end

      it 'handles redirect responses from the GeoServer installation' do
        get "/geoserver/restricted-figgy/wms?#{query}"

        expect(response).to redirect_to 'https://geoserver.institution.edu/geoserver'
      end
    end

    context "when the response indicates an authorization failure" do
      before do
        allow(proxied_response).to receive(:status).and_return(403)
        allow(proxied_response).to receive(:body).and_return('message')
        allow(Rails.logger).to receive(:error)
      end

      it 'handles and logs authorization errors' do
        get "/geoserver/restricted-figgy/wms?#{query}"

        expect(response.status).to eq 403
        expect(Rails.logger).to have_received(:error).with("Authorization failure for GeoServer request: https://geoserver.princeton.edu/geoserver/wms?#{query}: message")
      end
    end

    context "when the response indicates a internal service failure" do
      before do
        allow(proxied_response).to receive(:status).and_return(500)
        allow(proxied_response).to receive(:body).and_return('message')
        allow(Rails.logger).to receive(:error)
      end

      it 'handles and logs service errors' do
        get "/geoserver/restricted-figgy/wms?#{query}"

        expect(response.status).to eq 500
        expect(Rails.logger).to have_received(:error).with("Internal failure encountered for GeoServer request: https://geoserver.princeton.edu/geoserver/wms?#{query}: message")
      end
    end
  end
end
