# frozen_string_literal: true

require "rails_helper"

describe "Geoserver requests", type: :request do
  describe "#index" do
    let(:proxied_response) { instance_double(Faraday::Response) }
    let(:user) { FactoryBot.create(:user) }

    context "with a user is signed in" do
      before do
        sign_in user
        allow(Faraday).to receive(:get).and_return(proxied_response)
      end

      it "proxies GET requests to the GeoServer installation" do
        allow(proxied_response).to receive(:status).and_return(200)
        allow(proxied_response).to receive(:body).and_return("data")
        allow(proxied_response).to receive(:[]).with("Content-Type").and_return("application/octet-stream")

        get "/proxy/geodata/8d/0e/df/8d0edf/display_vector.pmtiles"

        expect(response).to be_successful
        expect(response.body).not_to be_empty
      end

      context "when the response indicates an authorization failure" do
        before do
          allow(proxied_response).to receive(:status).and_return(403)
          allow(proxied_response).to receive(:body).and_return("message")
          allow(Rails.logger).to receive(:error)
        end

        it "handles and logs authorization errors" do
          get "/proxy/geodata/8d/0e/df/8d0edf/display_vector.pmtiles"

          expect(response.status).to eq 403
          expect(Rails.logger).to have_received(:error).with("Authorization failure for geodata request: http://localhost:3000/fixtures/files/8d/0e/df/8d0edf/display_vector.pmtiles: message")
        end
      end

      context "when the response indicates a internal service failure" do
        before do
          allow(proxied_response).to receive(:status).and_return(500)
          allow(proxied_response).to receive(:body).and_return("message")
          allow(Rails.logger).to receive(:error)
        end

        it "handles and logs service errors" do
          get "/proxy/geodata/8d/0e/df/8d0edf/display_vector.pmtiles"

          expect(response.status).to eq 500
          expect(Rails.logger).to have_received(:error).with("Internal failure encountered for geodata request: http://localhost:3000/fixtures/files/8d/0e/df/8d0edf/display_vector.pmtiles: message")
        end
      end
    end
  end
end
