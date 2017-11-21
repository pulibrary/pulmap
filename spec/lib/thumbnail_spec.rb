require 'rails_helper'

describe Thumbnail do
  let(:thumbnail) { described_class.new(document) }
  let(:document) { SolrDocument.new(document_attributes) }
  let(:document_attributes) do
    { layer_slug_s: 'testdoc',
      layer_id_s: 'testlayer',
      dct_references_s: references,
      dc_rights_s: 'public' }
  end
  let(:references) {}

  before do
    allow(Settings.THUMBNAIL).to receive(:SIZE).and_return(256)
    allow(Settings.THUMBNAIL).to receive(:BASE_PATH).and_return('thumbnails')
    allow(Settings.THUMBNAIL).to receive(:FILE_BASE_PATH).and_return('./testroot/public')
    allow(Settings.THUMBNAIL).to receive(:USE_DCT_REFS).and_return(true)

    # Stub persistance so thumbnails aren't saved to disk.
    # allow(PersistThumbnailJob).to receive(:new).and_return(persist)
    allow(PersistThumbnailJob).to receive(:perform_later)
  end

  describe '#initialize' do
    it 'creates a Thumbnail object on initialization' do
      expect(thumbnail).to be_an described_class
    end
  end

  describe '#size' do
    it 'returns default size' do
      expect(thumbnail.size).to eq(256)
    end
  end

  describe '#thumb_path' do
    it 'returns default thumb path' do
      expect(thumbnail.thumb_path).to eq('thumbnails')
    end
  end

  describe '#file_base_path' do
    it 'returns default base file path' do
      expect(thumbnail.file_base_path).to eq('./testroot/public')
    end
  end

  describe '#name' do
    it 'returns the thumbnail name' do
      expect(thumbnail.name).to eq('testdoc')
    end
  end

  describe '#thumb_path_and_name' do
    it 'returns the thumbnail path and name' do
      path = 'thumbnails/4c/10/a9/5e/4c/b1/34/48/6d/8a/27/5e/f8/65/6c/a2/testdoc.png'
      expect(thumbnail.thumb_path_and_name).to eq(path)
    end
  end

  describe '#file_path_and_name' do
    it 'returns the thumbnail file path and name' do
      path = './testroot/public/thumbnails/4c/10/a9/5e/4c/b1/34/48/6d/8a/27/5e/f8/65/6c/a2/testdoc.png'
      expect(thumbnail.file_path_and_name).to eq(path)
    end
  end

  describe '#pair_path' do
    it 'returns a pair-tree path' do
      expect(thumbnail.pair_path).to eq('4c/10/a9/5e/4c/b1/34/48/6d/8a/27/5e/f8/65/6c/a2')
    end
  end

  context 'when document has no refs for generating a thumbnail' do
    let(:references) do
      {}.to_json
    end

    describe '#url' do
      it 'returns nil' do
        expect(thumbnail.url).to be_nil
      end
    end
  end

  context 'when document has a thumbnail reference' do
    let(:references) do
      {
        'http://schema.org/thumbnailUrl' => 'http://www.example.com/image.jpg'
      }.to_json
    end

    describe '#url' do
      it 'returns the thumbnail endpoint url' do
        expect(thumbnail.url).to eq('http://www.example.com/image.jpg')
      end
    end
  end

  context 'when document is a restricted scanned map with a thumbnail reference' do
    let(:document_attributes) do
      { layer_slug_s: 'testdoc',
        layer_id_s: 'testlayer',
        dct_provenance_s: 'Princeton',
        dct_references_s: references,
        dc_rights_s: 'Restricted',
        layer_geom_type_s: 'Image' }
    end
    let(:references) do
      {
        'http://schema.org/thumbnailUrl' => 'http://www.example.com/image.jpg'
      }.to_json
    end

    before { allow(Settings.THUMBNAIL).to receive(:USE_DCT_REFS).and_return(false) }

    describe '#url' do
      it 'returns the thumbnail endpoint url' do
        expect(thumbnail.url).to eq('http://www.example.com/image.jpg')
      end
    end
  end

  context 'when document has a wms reference' do
    let(:references) do
      {
        'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://www.example.com/wms'
      }.to_json
    end
    let(:wms_service_url) do
      'http://www.example.com/wms/reflect?&FORMAT=image%2Fpng&'\
                            'TRANSPARENT=TRUE&LAYERS=testlayer&WIDTH=256&HEIGHT=256'
    end

    describe '#url' do
      it 'returns a web map service thumbnail url' do
        expect(thumbnail.url).to eq(wms_service_url)
      end
    end

    describe '#generated_thumbnail' do
      context 'when cached thumbnail file already exists' do
        it 'returns url to cached thumbnail' do
          allow(File).to receive('file?').with(thumbnail.file_path_and_name).and_return(true)
          expect(thumbnail.generated_thumbnail).to eq(thumbnail.thumb_path_and_name)
        end
      end

      context 'when cached thumbnail file does not exist' do
        it 'triggers a save thread and returns a url to wms service' do
          allow(File).to receive(:file?).with(thumbnail.file_path_and_name).and_return(false)
          allow(File).to receive(:file?).with("#{thumbnail.file_path_and_name}.tmp").and_return(false)
          allow(File).to receive(:file?).with("#{thumbnail.file_path_and_name}.error").and_return(false)
          allow(thumbnail).to receive(:save_thumbnail).and_return('http://www.example.com/test/wms')
          expect(thumbnail.generated_thumbnail).to eq(wms_service_url)
        end
      end

      context 'when thumbnail error file does exist' do
        it 'returns nil' do
          allow(File).to receive(:file?).with(thumbnail.file_path_and_name).and_return(false)
          allow(File).to receive(:file?).with("#{thumbnail.file_path_and_name}.tmp").and_return(false)
          allow(File).to receive(:file?).with("#{thumbnail.file_path_and_name}.error").and_return(true)
          expect(thumbnail.generated_thumbnail).to be_nil
        end
      end

      context 'when thumbnail temp file does exist' do
        it 'returns url to wms service' do
          allow(File).to receive(:file?).with(thumbnail.file_path_and_name).and_return(false)
          allow(File).to receive(:file?).with("#{thumbnail.file_path_and_name}.tmp").and_return(true)
          allow(File).to receive(:file?).with("#{thumbnail.file_path_and_name}.error").and_return(false)
          expect(thumbnail.generated_thumbnail).to eq(wms_service_url)
        end
      end
    end

    context 'when document has a wms reference and a thumbnail reference' do
      let(:references) do
        {
          'http://schema.org/thumbnailUrl' => 'http://www.example.com/image.jpg',
          'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://www.example.com/wms'
        }.to_json
      end
      let(:wms_service_url) do
        'http://www.example.com/wms/reflect?&FORMAT=image%2Fpng&'\
          'TRANSPARENT=TRUE&LAYERS=testlayer&WIDTH=256&HEIGHT=256'
      end

      context 'when use of thumbnail endpoint urls are turned off in settings' do
        describe '#url' do
          it 'returns a web map service thumbnail url' do
            allow(Settings.THUMBNAIL).to receive(:USE_DCT_REFS).and_return(false)
            expect(thumbnail.url).to eq(wms_service_url)
          end
        end
      end
    end

    describe '#service_url' do
      context 'when document is unavailable' do
        it 'returns nil' do
          allow(document).to receive(:available?).and_return(false)
          expect(thumbnail.service_url).to eq(nil)
        end
      end

      context 'when viewer protocol is map' do
        it 'returns nil' do
          allow(document).to receive(:viewer_protocol).and_return('map')
          expect(thumbnail.service_url).to eq(nil)
        end
      end

      context 'when viewer protocol is unsupported' do
        it 'returns nil' do
          allow(document).to receive(:viewer_protocol).and_return('obscure_protocol')
          expect(thumbnail.service_url).to eq(nil)
        end
      end
    end

    describe '#save_thumbnail' do
      it 'creates a new persist thumbnail job' do
        allow(PersistThumbnailJob).to receive(:perform_later)
        thumbnail.save_thumbnail
        expect(PersistThumbnailJob).to have_received(:perform_later)
      end
    end

    describe '#geoserver_credentials' do
      let(:credentials) { 'base64encodedusername:password' }

      context 'with a restricted Princeton document' do
        before do
          document_attributes.merge!(dct_provenance_s: 'Princeton', dc_rights_s: 'Restricted')
        end

        it 'returns base64 encoded geoserver auth credentials' do
          expect(thumbnail.geoserver_credentials).to eq(credentials)
        end
      end
    end
  end
end
