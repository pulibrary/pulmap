require 'rails_helper'

describe Geoblacklight::Download do
  let(:connection) { instance_double('Faraday::Connection') }
  let(:download) { Geoblacklight::ShapefileDownload.new(document, options) }
  let(:options) do
    {
      type: 'shapefile',
      extension: 'zip',
      service_type: 'wms',
      content_type: 'application/zip'
    }
  end
  let(:references) do
    { 'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://www.example.com/wms' }.to_json
  end
  let(:request) { instance_double('Faraday::Request') }

  before do
    allow(Faraday).to receive(:new).and_return(connection)
    allow(connection).to receive(:get).and_return(request)
    allow(Settings).to receive(:PROXY_GEOSERVER_AUTH).and_return("realuser:realpass")
    allow(connection).to receive(:authorization)
  end

  describe '#initiate_download' do
    context 'with a public record with wms endpoint' do
      let(:document) do
        SolrDocument.new(layer_slug_s: 'test',
                         dct_references_s: references)
      end

      it 'requests download from server without using basic authorization' do
        download.initiate_download
        expect(Faraday).to have_received(:new).with(url: 'http://www.example.com/wms')
        expect(connection).not_to have_received(:authorization).with(:Basic, "realuser:realpass")
      end
    end

    context 'with a non-public princeton record with wms endpoint' do
      let(:document) do
        SolrDocument.new(layer_slug_s: 'test',
                         dct_provenance_s: 'Princeton',
                         dc_rights_s: 'Restricted',
                         dct_references_s: references)
      end

      it 'request download from server using basic authorization' do
        download.initiate_download
        expect(Faraday).to have_received(:new).with(url: 'http://www.example.com/wms')
        expect(connection).to have_received(:authorization).with(:Basic, "realuser:realpass")
      end
    end
  end
end
