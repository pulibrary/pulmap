# frozen_string_literal: true

require Rails.root.join('app', 'services', 'robots_generator_service').to_s

desc 'Run test suite'
task :ci do
  shared_solr_opts = { managed: true, verbose: true, persist: false, download_dir: 'tmp' }
  shared_solr_opts[:version] = ENV['SOLR_VERSION'] if ENV['SOLR_VERSION']

  SolrWrapper.wrap(shared_solr_opts.merge(port: 8985, instance_dir: 'tmp/pulmap-core-test')) do |solr|
    solr.with_collection(name: "pulmap-core-test", dir: Rails.root.join("solr", "conf").to_s) do
      system 'RAILS_ENV=test rake geoblacklight:index:seed'
      Rake::Task['spec'].invoke
    end
  end
end

namespace :pulmap do
  namespace :solr do
    desc 'Updates solr config files from github'
    task :update, :solr_dir do |_t, args|
      solr_dir = args[:solr_dir] || Rails.root.join('solr', 'conf')

      ['mapping-ISOLatin1Accent.txt', 'protwords.txt', 'schema.xml', 'solrconfig.xml',
       'spellings.txt', 'stopwords.txt', 'stopwords_en.txt', 'synonyms.txt'].each do |file|
        response = Faraday.get url_for_file("conf/#{file}")
        File.open(File.join(solr_dir, file), 'wb') { |f| f.write(response.body) }
      end
    end
  end

  namespace :server do
    desc "Start solr and postgres servers using lando."
    task :start do
      system('lando start')
      system('rake pulmap:server:seed')
      system('rake pulmap:server:seed RAILS_ENV=test')
    end

    task :seed do
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
      Rake::Task['geoblacklight:solr:seed'].invoke
    end

    desc "Stop lando solr and postgres servers."
    task :stop do
      system('lando stop')
    end
  end

  desc 'Generate a robots.txt file'
  task :robots_txt do |_t, args|
    file_path = args[:file_path] || Rails.root.join('public', 'robots.txt')
    robots = RobotsGeneratorService.new(path: file_path, disallowed_paths: Rails.configuration.robots.disallowed_paths)
    robots.insert_group(user_agent: '*')
    robots.insert_crawl_delay(10)
    robots.insert_sitemap(Rails.configuration.robots.sitemap_url)
    robots.generate
    robots.write
  end

  namespace :geoblacklight_harvester do
    desc 'Harvest documents from a configured GeoBlacklight instance'
    task :index, [:site] => [:environment] do |_t, args|
      raise ArgumentError, 'A site argument is required' unless args.site

      # Set the solr url for GeoCombine
      ENV["SOLR_URL"] = Blacklight.connection_config[:url]

      GeoCombine::GeoBlacklightHarvester.new(args.site.to_sym).index

      # Commit all added docs
      Blacklight.default_index.connection.commit
    end
  end

  private

  def url_for_file(file)
    "https://raw.githubusercontent.com/pulibrary/pul_solr/master/solr_configs/pulmap/#{file}"
  end
end
