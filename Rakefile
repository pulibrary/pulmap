require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

BLACKLIGHT_JETTY_VERSION = '4.10.4'
ZIP_URL = "https://github.com/projectblacklight/blacklight-jetty/archive/v#{BLACKLIGHT_JETTY_VERSION}.zip"

require 'jettywrapper'
require 'rspec/core/rake_task'

task default: :ci

unless Rails.env == 'production'
  require 'rubocop/rake_task'

  desc 'Run style checker'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.fail_on_error = true
  end
end

desc 'Run test suite and style checker'
task spec: :rubocop do
  RSpec::Core::RakeTask.new(:spec)
end

desc 'Execute the test build that runs on travis'
task ci: [:environment] do
  if Rails.env.test?
    Rake::Task['pulmap:setup_db_and_jetty'].invoke
    jetty_params = Jettywrapper.load_config
    Jettywrapper.wrap(jetty_params) do
      Rake::Task['geoblacklight:solr:seed'].invoke

      # run the tests
      Rake::Task['spec'].invoke
    end
  else
    system('rake ci RAILS_ENV=test')
  end
end
