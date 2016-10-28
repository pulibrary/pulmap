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
      expect(download).to receive(:class).twice.and_return(Faraday::Response)
      expect(persist).to receive(:create_temp_file)
      expect(persist).to receive(:initiate_download).and_return(download)
      expect(persist).to receive(:save_file).with(download)
      persist.create_file
    end

    it 'creates temp file and returns nil if there is a problem' do
      expect(persist).to receive(:create_temp_file)
      expect(persist).to receive(:initiate_download).and_return(nil)
      expect(persist.create_file).to be_nil
    end
  end

  describe '#create_temp_file' do
    it 'creates a temp file in the fs in a new directory' do
      expect(File).to receive(:directory?).with(File.dirname(file_path)).and_return(false)
      expect(FileUtils).to receive(:mkdir_p).with(File.dirname(file_path))
      expect(File).to receive(:open).with("#{file_path}.tmp", 'wb').and_return('')
      persist.create_temp_file
    end

    it 'creates a temp file in the fs in an existing directory' do
      expect(File).to receive(:directory?).with(File.dirname(file_path)).and_return(true)
      expect(File).to receive(:open).with("#{file_path}.tmp", 'wb').and_return('')
      persist.create_temp_file
    end
  end

  describe '#initiate_download' do
    it 'request thumbnail from server' do
      expect(Faraday).to receive(:new).with(url: 'http://www.example.com/thumbnail').and_return(connection)
      expect(connection).to receive(:get).and_yield(request)
      expect(request).to receive(:options).and_return(req_options).twice
      persist.initiate_download
    end
    it 'creates a thumbnail error file with a connection failure' do
      expect(connection).to receive(:get).and_raise(Faraday::Error::ConnectionFailed.new('Failed'))
      expect(Faraday).to receive(:new).with(url: 'http://www.example.com/thumbnail').and_return(connection)
      expect(File).to receive(:rename).with("#{file_path}.tmp", "#{file_path}.error")
      persist.initiate_download
    end
    it 'creates a thumbnail error file with a timeout error' do
      expect(connection).to receive(:get).and_raise(Faraday::Error::TimeoutError.new('Time Out'))
      expect(Faraday).to receive(:new).with(url: 'http://www.example.com/thumbnail').and_return(connection)
      expect(File).to receive(:rename).with("#{file_path}.tmp", "#{file_path}.error")
      persist.initiate_download
    end
  end

  describe '#save_file' do
    it 'opens the temp file and deletes it if the content headers are not correct' do
      bad_file = OpenStruct.new(headers: { 'content-type' => 'bad/file' })
      expect(File).to receive(:rename).with("#{file_path}.tmp", "#{file_path}.error")
      persist.save_file(bad_file)
    end

    it 'opens the temp file, writes to it, and then renames from tmp if everything is ok' do
      good_file = OpenStruct.new(headers: { 'content-type' => 'image/png' })
      expect(File).to receive(:open).with("#{file_path}.tmp", 'wb').and_yield(thumb_file)
      expect(thumb_file).to receive(:write)
      expect(File).to receive(:rename).with("#{file_path}.tmp", file_path.to_s)
      persist.save_file(good_file)
    end
  end
end
