class PersistThumbnail
  ##
  # @param [Hash] options
  # @option options [String] :url the thumbnail url
  # @option options [String] :file_path thumbnail file name and path
  # @option options [String] :content_type mime type of thumbnail
  # @option options [Integer] :url download timout value in seconds
  def initialize(options)
    @url = options[:url]
    @file_path = options[:file_path]
    @content_type = options[:content_type]
    @timeout = options[:timeout]
  end

  ##
  # Downloads a thumbnail from its service URL and caches it for later use.
  # Creates a temporary file for the downloaded thumbnail
  # @return [String] file name of the downloaded thumbnail
  def create_file
    create_temp_file
    download = initiate_download
    return if download.nil?
    return unless download.class == Faraday::Request
    save_file(download)
  end

  ##
  # Appends ".tmp" extension to file name and creates an empty temp file.
  def create_temp_file
    unless File.directory?(File.dirname(@file_path))
      FileUtils.mkdir_p(File.dirname(@file_path))
    end
    File.open("#{@file_path}.tmp", 'wb') {}
  end

  ##
  # Initiates a download from a remote source using the thumbnail
  # service endpoint url.
  # Catches Faraday::Error::ConnectionFailed and
  # Faraday::Error::TimeoutError
  # @return [Faraday::Request] returns a Faraday::Request object
  def initiate_download
    conn = Faraday.new(url: @url)
    conn.get do |request|
      request.options.timeout = @timeout
      request.options.open_timeout = @timeout
    end
  rescue Faraday::Error::ConnectionFailed
    File.rename("#{@file_path}.tmp", "#{@file_path}.error")
  rescue Faraday::Error::TimeoutError
    File.rename("#{@file_path}.tmp", "#{@file_path}.error")
  end

  ##
  # Attempts to save the thumbnail to the previously created temp file,
  # and renames it if the download is successful or there is an error.
  # @param [Faraday::Request]
  # @return [String] file name of the downloaded thumbnail
  def save_file(download)
    if download.headers['content-type'] == @content_type
      File.open("#{@file_path}.tmp", 'wb') do |file|
        file.write download.body
      end
    else
      raise Geoblacklight::Exceptions::WrongDownloadFormat
    end
    File.rename("#{@file_path}.tmp", @file_path.to_s)
  rescue Geoblacklight::Exceptions::WrongDownloadFormat
    suppress(Exception) { File.rename("#{@file_path}.tmp", "#{@file_path}.error") }
  end
end
