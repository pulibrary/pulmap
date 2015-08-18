namespace :pulmap do
  namespace :solr do
    desc "Put sample data into solr"
    task :seed => :environment do
      docs = Dir['test/fixtures/solr_documents/*.json'].map { |f| JSON.parse File.read(f) }.flatten
      Blacklight.default_index.connection.add docs
      Blacklight.default_index.connection.commit
    end
  end
end
