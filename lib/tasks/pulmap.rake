namespace :pulmap do
  desc 'Setup Pulmap'
  task setup: [:environment] do
    Rake::Task['pulmap:setup_db_and_jetty'].invoke
    Jettywrapper.wrap(Jettywrapper.load_config) do
      Rake::Task['geoblacklight:solr:seed'].invoke
    end
  end
  desc 'Setup database and jetty'
  task :setup_db_and_jetty do
    Rake::Task['db:migrate'].invoke
    Rake::Task['pulmap:download_and_unzip_jetty'].invoke
    Rake::Task['pulmap:configure_jetty'].invoke
  end
  desc 'Download and unzip jetty'
  task :download_and_unzip_jetty do
    unless File.exist?("#{Rails.root}/jetty")
      puts 'Downloading jetty'
      Rake::Task['jetty:download'].invoke
      puts 'Unzipping jetty'
      Rake::Task['jetty:unzip'].invoke
    end
  end
  desc 'Configure jetty'
  task :configure_jetty do
    %w(schema solrconfig).each do |file|
      cp "#{Rails.root}/config/solr_configs/#{file}.xml", "#{Rails.root}/jetty/solr/blacklight-core/conf/"
    end
  end
end
