namespace :pulmap do

  namespace :solr do
    desc 'Updates solr config files from github'
    task :update, :solr_dir do |t, args|
      solr_dir = args[:solr_dir] || Rails.root.join('solr', 'conf')

      ['mapping-ISOLatin1Accent.txt', 'protwords.txt', 'schema.xml', 'solrconfig.xml',
       'spellings.txt', 'stopwords.txt', 'stopwords_en.txt', 'synonyms.txt'].each do |file|
        response = Faraday.get url_for_file("conf/#{file}")
        File.open(File.join(solr_dir, file), 'wb') { |f| f.write(response.body) }
      end
    end
  end

  private

    def url_for_file(file)
      "https://raw.githubusercontent.com/pulibrary/pul_solr/master/solr_configs/pulmap/#{file}"
    end
end
