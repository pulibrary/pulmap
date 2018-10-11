require Rails.root.join('app', 'services', 'robots_generator_service').to_s

desc 'Run test suite'
task :ci do
  shared_solr_opts = { managed: true, verbose: true, persist: false, download_dir: 'tmp' }
  shared_solr_opts[:version] = ENV['SOLR_VERSION'] if ENV['SOLR_VERSION']

  SolrWrapper.wrap(shared_solr_opts.merge(port: 8985, instance_dir: 'tmp/pulmap-core-test')) do |solr|
    solr.with_collection(name: "pulmap-core-test", dir: Rails.root.join("solr", "conf").to_s) do
      system 'RAILS_ENV=test rake geoblacklight:index:seed'
      system 'RAILS_ENV=test rake spec'
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

  desc "Start solr server for testing."
  task :test do
    if Rails.env.test?
      shared_solr_opts = { managed: true, verbose: true, persist: false, download_dir: 'tmp' }
      shared_solr_opts[:version] = ENV['SOLR_VERSION'] if ENV['SOLR_VERSION']

      SolrWrapper.wrap(shared_solr_opts.merge(port: 8985, instance_dir: 'tmp/pulmap-core-test')) do |solr|
        solr.with_collection(name: "pulmap-core-test", dir: Rails.root.join("solr", "conf").to_s) do
          puts "Solr running at http://localhost:8985/solr/pulmap-core-test/, ^C to exit"
          begin
            Rake::Task['geoblacklight:solr:seed'].invoke
            sleep
          rescue Interrupt
            puts "\nShutting down..."
          end
        end
      end
    else
      system('rake pulmap:test RAILS_ENV=test')
    end
  end

  desc "Start solr server for development."
  task :development do
    SolrWrapper.wrap(managed: true, verbose: true, port: 8983, instance_dir: 'tmp/pulmap-core-dev', persist: false, download_dir: 'tmp') do |solr|
      solr.with_collection(name: "pulmap-core-dev", dir: Rails.root.join("solr", "conf").to_s) do
        puts "Setup solr"
        puts "Solr running at http://localhost:8983/solr/pulmap-core-dev/, ^C to exit"
        begin
          Rake::Task['geoblacklight:solr:seed'].invoke
          sleep
        rescue Interrupt
          puts "\nShutting down..."
        end
      end
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

  private

  def url_for_file(file)
    "https://raw.githubusercontent.com/pulibrary/pul_solr/master/solr_configs/pulmap/#{file}"
  end
end
