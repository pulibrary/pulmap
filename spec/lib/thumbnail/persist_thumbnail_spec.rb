require 'rails_helper'

describe PersistThumbnail do
  let(:connection) { instance_double('Faraday::Connection') }
  let(:request) { instance_double('Faraday::Request') }
  let(:req_options) { instance_double('opts', 'timeout=' => 60, 'open_timeout=' => 60) }
  let(:persist) { described_class.new(options) }
  let(:download) { instance_double('Faraday::Response') }
  let(:file_path) { './test/thumbnail.png' }
  let(:thumb_file) { instance_double(File) }
  let(:url) { 'http://www.example.com/thumbnail' }
  let(:content_type) { 'image/png' }
  let(:options) do
    { url: url,
      file_path: file_path,
      content_type: content_type,
      timeout: 60 }
  end

  describe '#initialize' do
    it 'creates a persist object on initialization' do
      expect(persist).to be_a described_class
    end
  end

  describe '#create_file' do
    it 'creates temp file, downloads thumbnail and saves it' do
      allow(download).to receive(:class).twice.and_return(Faraday::Response)
      allow(persist).to receive(:create_temp_file)
      allow(persist).to receive(:initiate_download).and_return(download)
      allow(persist).to receive(:save_file)
      persist.create_file
      expect(persist).to have_received(:save_file).with(download)
    end

    it 'creates temp file and returns nil if there is a problem' do
      allow(persist).to receive(:create_temp_file)
      allow(persist).to receive(:initiate_download).and_return(nil)
      expect(persist.create_file).to be_nil
    end
  end

  describe '#create_temp_file' do
    it 'creates a temp file in the fs in a new directory' do
      allow(File).to receive(:directory?).with(File.dirname(file_path)).and_return(false)
      allow(FileUtils).to receive(:mkdir_p).with(File.dirname(file_path))
      allow(File).to receive(:open)
      persist.create_temp_file
      expect(File).to have_received(:open).with("#{file_path}.tmp", 'wb')
    end

    it 'creates a temp file in the fs in an existing directory' do
      allow(File).to receive(:directory?).with(File.dirname(file_path)).and_return(true)
      allow(File).to receive(:open)
      persist.create_temp_file
      expect(File).to have_received(:open).with("#{file_path}.tmp", 'wb')
    end
  end

  describe '#initiate_download' do
    it 'requests thumbnail from server' do
      allow(Faraday).to receive(:new).and_return(connection)
      allow(connection).to receive(:get).and_yield(request)
      allow(request).to receive(:options).and_return(req_options)
      persist.initiate_download
      expect(Faraday).to have_received(:new).with(url: 'http://www.example.com/thumbnail')
    end
    it 'creates a thumbnail error file with a connection failure' do
      allow(connection).to receive(:get).and_raise(Faraday::Error::ConnectionFailed.new('Failed'))
      allow(Faraday).to receive(:new).with(url: 'http://www.example.com/thumbnail').and_return(connection)
      allow(File).to receive(:rename)
      persist.initiate_download
      expect(File).to have_received(:rename).with("#{file_path}.tmp", "#{file_path}.error")
    end
    it 'creates a thumbnail error file with a timeout error' do
      allow(connection).to receive(:get).and_raise(Faraday::Error::TimeoutError.new('Time Out'))
      allow(Faraday).to receive(:new).with(url: 'http://www.example.com/thumbnail').and_return(connection)
      allow(File).to receive(:rename)
      persist.initiate_download
      expect(File).to have_received(:rename).with("#{file_path}.tmp", "#{file_path}.error")
    end
  end

  describe '#save_file' do
    it 'opens the temp file and deletes it if the content headers are not correct' do
      bad_file = OpenStruct.new(headers: { 'content-type' => 'bad/file' })
      allow(File).to receive(:rename)
      persist.save_file(bad_file)
      expect(File).to have_received(:rename).with("#{file_path}.tmp", "#{file_path}.error")
    end

    it 'opens the temp file, writes to it, and then renames from tmp if everything is ok' do
      good_file = OpenStruct.new(headers: { 'content-type' => 'image/png' })
      allow(File).to receive(:open).with("#{file_path}.tmp", 'wb').and_yield(thumb_file)
      allow(thumb_file).to receive(:write)
      allow(File).to receive(:rename)
      persist.save_file(good_file)
      expect(File).to have_received(:rename).with("#{file_path}.tmp", file_path.to_s)
    end
  end
end
