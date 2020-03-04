# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ThumbnailsController, type: :controller do
  describe "GET #index" do
    let(:connection) { instance_double('Faraday::Connection') }
    let(:request) { instance_double('Faraday::Request') }
    let(:req_options) { instance_double('opts', 'timeout=' => 30, 'open_timeout=' => 30) }
    let(:placeholder_base) { Rails.root.join("app", "assets", "images") }

    before do
      allow(Faraday).to receive(:new).and_return(connection)
      allow(connection).to receive(:get).and_return(request)
      allow(connection).to receive(:options).and_return(req_options)
      allow(request).to receive(:body).and_return('image data')
      Rails.cache.clear
    end

    after do
      Rails.cache.clear
    end

    context "with a WMS layer" do
      let(:placeholder) { File.read(Rails.root.join(placeholder_base, "thumbnail-polygon.png")) }

      it "caches a generated WMS thumbnail" do
        get :index, params: { id: "nyu_2451_34548" }
        expect(Faraday).to have_received(:new).with(url: %r{nyu.edu\/geoserver\/sdr\/wms\/reflect})
      end
      it "returns a placeholder image on first get request" do
        get :index, params: { id: "nyu_2451_34548" }
        expect(response.body).to eq placeholder
      end
      it "returns the generated thumbnail on second get request" do
        get :index, params: { id: "nyu_2451_34548" }
        get :index, params: { id: "nyu_2451_34548" }
        expect(response.body).not_to eq placeholder
      end

      context "when a thumbnail cannot be retrieved" do
        let(:placeholder) { File.read(Rails.root.join(placeholder_base, "thumbnail-paper-map.png")) }
        before do
          allow(Rails.logger).to receive(:error)
        end

        it "returns the paper map placeholder" do
          get :index, params: { id: "uva-FullUSGS-FGDCmetadata(UVAcopy)" }
          expect(response.body).to eq placeholder
          expect(Rails.logger).to have_received(:error).with("Failed to retrieve the thumbnail for: uva-FullUSGS-FGDCmetadata(UVAcopy)").at_least(:once)
        end
      end
    end

    context "with a iiif layer" do
      it "caches a generated thumbnail" do
        get :index, params: { id: "princeton-02870w62c" }
        expect(Faraday).to have_received(:new).with(url: %r{map_pownall\/00000001.jp2})
      end
    end

    context "with a dynamic map layer" do
      it "caches a generated thumbnail" do
        get :index, params: { id: "90f14ff4-1359-4beb-b931-5cb41d20ab90" }
        expect(Faraday).to have_received(:new).with(url: %r{Glacial_Boundaries\/MapServer\/info})
      end
    end

    context "with a tiled map layer" do
      it "caches a generated thumbnail" do
        get :index, params: { id: "nyu-test-soil-survey-map" }
        expect(Faraday).to have_received(:new).with(url: %r{Soil_Survey_Map\/MapServer\/info})
      end
    end

    context "with an image map layer" do
      it "caches a generated thumbnail" do
        get :index, params: { id: "32653ed6-8d83-4692-8a06-bf13ffe2c018" }
        expect(Faraday).to have_received(:new).with(url: %r{wabashtopo\/ImageServer\/info})
      end
    end

    context "with a restricted Princeton scanned map" do
      it "caches a static thumbnail" do
        get :index, params: { id: "princeton-kk91fn37z" }
        expect(Faraday).to have_received(:new).with(url: %r{file\/6e0974f3-4bb8-40cb-81a7-baf82975617f})
      end
    end

    context "with a restricted Princeton WMS layer, and properly set geoserver credentials" do
      before do
        allow(Settings).to receive(:PROXY_GEOSERVER_AUTH).and_return("realuser:realpass")
        allow(connection).to receive(:authorization)
      end

      it "uses basic authorization" do
        get :index, params: { id: "princeton-m613n013z" }
        expect(connection).to have_received(:authorization).with(:Basic, "realuser:realpass")
      end
      it "caches a thumbnail via geoserver server and not the geoserver proxy" do
        get :index, params: { id: "princeton-m613n013z" }
        expect(Faraday).to have_received(:new)
          .with(url: /geoserver.princeton.edu.*restricted-figgy:p-735d9ddb/)
      end
    end

    context "with a restricted Princeton WMS layer, and geoserver credentials set to default" do
      before do
        allow(connection).to receive(:authorization)
      end

      it "caches a static thumbnail" do
        get :index, params: { id: "princeton-m613n013z" }
        expect(Faraday).to have_received(:new).with(url: %r{downloads\/735d9ddb})
      end
    end

    context "with an unavailable document" do
      let(:placeholder) { File.read(Rails.root.join(placeholder_base, "thumbnail-image.png")) }

      it "caches the place holder image" do
        get :index, params: { id: "princeton-fk4bk1p41f" }
        get :index, params: { id: "princeton-fk4bk1p41f" }
        expect(response.body).to eq placeholder
      end
    end

    context "with an unimplemented service url generator" do
      it "caches a static thumbnail" do
        get :index, params: { id: "f406332e63eb4478a9560ad86ae90327_18" }
        expect(Faraday).to have_received(:new).with(url: "http://exampleserver/thumbnail.png")
      end
    end

    context "with a failed connection" do
      let(:placeholder) { File.read(Rails.root.join(placeholder_base, "thumbnail-polygon.png")) }

      before do
        allow(connection).to receive(:get).and_raise(Faraday::ConnectionFailed.new('Failed'))
      end

      it "caches the place holder image" do
        get :index, params: { id: "nyu_2451_34548" }
        get :index, params: { id: "nyu_2451_34548" }
        expect(response.body).to eq placeholder
      end
    end

    context "with a timed-out request" do
      let(:placeholder) { File.read(Rails.root.join(placeholder_base, "thumbnail-polygon.png")) }

      before do
        allow(connection).to receive(:get).and_raise(Faraday::TimeoutError.new('Failed'))
      end

      it "caches the placeholder image" do
        get :index, params: { id: "nyu_2451_34548" }
        get :index, params: { id: "nyu_2451_34548" }
        expect(response.body).to eq placeholder
      end
    end

    context "with a request that has an SSL error" do
      let(:placeholder) { File.read(Rails.root.join(placeholder_base, "thumbnail-polygon.png")) }

      before do
        allow(connection).to receive(:get).and_raise(Faraday::SSLError.new('Failed'))
      end

      it "caches the placeholder image" do
        get :index, params: { id: "nyu_2451_34548" }
        get :index, params: { id: "nyu_2451_34548" }
        expect(response.body).to eq placeholder
      end
    end
  end
end
