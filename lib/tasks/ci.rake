require 'solr_wrapper'

desc 'Run test suite'
task :ci do
  if Rails.env.test?
    Rake::Task['rubocop'].invoke
    run_solr('ci', port: '8985', ignore_md5sum: true) do
      Rake::Task['geoblacklight:solr:seed'].invoke
      Rake::Task['spec'].invoke
    end
  else
    system('rake ci RAILS_ENV=test')
  end
end

namespace :server do
  desc 'Run Solr for development environment'
  task :development do
    run_solr('development', port: '8983') do
      Rake::Task['geoblacklight:solr:seed'].invoke
      begin
        sleep
      rescue Interrupt
        puts 'Shutting down...'
      end
    end
  end
  desc 'Run Solr for test environment'
  task :test do
    if Rails.env.test?
      run_solr('ci', port: '8985') do
        Rake::Task['geoblacklight:solr:seed'].invoke
        begin
          sleep
        rescue Interrupt
          puts 'Shutting down...'
        end
      end
    else
      system('rake server:test RAILS_ENV=test')
    end
  end
end

def run_solr(environment, solr_params)
  solr_dir = File.join(File.expand_path('.', File.dirname(__FILE__)),
                       '../../', 'solr', 'conf')
  SolrWrapper.wrap(solr_params) do |solr|
    ENV['SOLR_TEST_PORT'] = solr.port

    # additional solr configuration
    Rake::Task['pulmap:solr:update'].invoke(solr_dir)
    solr.with_collection(name: 'blacklight-core', dir: File.join(solr_dir)) do
      puts "\n#{environment.titlecase} solr server running: http://localhost:#{solr.port}/solr/#/blacklight-core"
      puts "\n^C to stop"
      puts ' '
      begin
        yield
      rescue Interrupt
        puts 'Shutting down...'
      end
    end
  end
end
