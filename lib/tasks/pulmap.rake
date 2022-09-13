# frozen_string_literal: true
require Rails.root.join("app", "services", "robots_generator_service").to_s

namespace :servers do
  desc "Start solr and postgres servers using lando."
  task :start do
    system("lando start")
    system("rake servers:seed")
    system("rake servers:seed RAILS_ENV=test")
  end

  task :seed do
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["geoblacklight:solr:seed"].invoke
  end

  desc "Stop lando solr and postgres servers."
  task :stop do
    system("lando stop")
  end
end

namespace :pulmap do
  namespace :geocombine do
    # This task is copied from
    # https://github.com/OpenGeoMetadata/GeoCombine/blob/f5f9e45599b3c388d2e5e5401fa91639b23a584e/lib/tasks/geo_combine.rake#L40-L58
    # and modified to skip records in the aardvark metadata schema
    # when we use aardvark it will need to be updated or maybe there will be a
    # flag for the rake task provided by geocombine
    desc "Index all JSON documents except Layers.json"
    task :index do
      ogm_path = Rails.root.join("tmp", "opengeometadata")
      solr = Blacklight.default_index.connection
      Find.find(ogm_path) do |path|
        next if path.to_s.include?("aardvark")
        next unless File.basename(path).include?(".json") && File.basename(path) != "layers.json"

        doc = JSON.parse(File.read(path))
        [doc].flatten.each do |record|
          puts "Indexing #{record['layer_slug_s']}: #{path}" if $DEBUG
          solr.update params: { commitWithin: 1000, overwrite: true },
                      data: [record].to_json,
                      headers: { "Content-Type" => "application/json" }
        rescue RSolr::Error::Http => e
          puts e
        end
      end
      solr.commit
    end
  end

  namespace :solr do
    desc "Updates solr config files from github"
    task :update, :solr_dir do |_t, args|
      solr_dir = args[:solr_dir] || Rails.root.join("solr", "conf")

      ["mapping-ISOLatin1Accent.txt", "protwords.txt", "schema.xml", "solrconfig.xml",
       "spellings.txt", "stopwords.txt", "stopwords_en.txt", "synonyms.txt"].each do |file|
        response = Faraday.get url_for_file("conf/#{file}")
        File.open(File.join(solr_dir, file), "wb") { |f| f.write(response.body) }
      end
    end
  end

  desc "Generate a robots.txt file"
  task :robots_txt do |_t, args|
    file_path = args[:file_path] || Rails.public_path.join("robots.txt")
    robots = RobotsGeneratorService.new(path: file_path, disallowed_paths: Rails.configuration.robots.disallowed_paths)
    robots.insert_group(user_agent: "*")
    robots.insert_crawl_delay(10)
    robots.insert_sitemap(Rails.configuration.robots.sitemap_url)
    robots.generate
    robots.write
  end

  namespace :geoblacklight_harvester do
    desc "Harvest documents from a configured GeoBlacklight instance"
    task :index, [:site] => [:environment] do |_t, args|
      raise ArgumentError, "A site argument is required" unless args.site

      # Set the solr url for GeoCombine
      ENV["SOLR_URL"] = Blacklight.connection_config[:url]

      GeoCombine::GeoBlacklightHarvester.new(args.site.to_sym).index

      # Commit all added docs
      Blacklight.default_index.connection.commit
    end
  end

  namespace :delete_record do
    desc "Delete a single record"
    task :index, :id do |_t, args|
      # Set up connection and args
      solr = Blacklight.default_index.connection
      id = args[:id]
      raise ArgumentError, "An id argument is required" unless id

      # Delete and commit
      solr.delete_by_query "layer_slug_s:#{RSolr.solr_escape(id)}"
      solr.commit
    end
  end

  private

  def url_for_file(file)
    "https://raw.githubusercontent.com/pulibrary/pul_solr/main/solr_configs/pulmap/#{file}"
  end
end
