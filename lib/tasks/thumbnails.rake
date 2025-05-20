# frozen_string_literal: true

namespace :gblsci do
  namespace :images do
    desc "Harvest all new thumbnails"
    task harvest_new: :environment do
      query = "*:*"
      index = Geoblacklight::SolrDocument.index
      results = index.send_and_receive(index.blacklight_config.solr_path,
                                       q: query,
                                       fl: "*",
                                       rows: 100_000_000)
      results.docs.each do |document|
        if document.sidecar.image_state.last_transition.nil?
          GeoblacklightSidecarImages::StoreImageJob.perform_later(document.id)
        end
      rescue Blacklight::Exceptions::RecordNotFound
        next
      end
    end

    desc "Harvest all images without built-in pause between records"
    task harvest_all_quick: :environment do
      query = "*:*"
      index = Geoblacklight::SolrDocument.index
      results = index.send_and_receive(index.blacklight_config.solr_path,
                                       q: query,
                                       fl: "*",
                                       rows: 100_000_000)
      results.docs.each do |document|
        GeoblacklightSidecarImages::StoreImageJob.perform_later(document.id)
      rescue Blacklight::Exceptions::RecordNotFound
        next
      end
    end

    desc "Harvest images by solr query"
    task :harvest_by_query, [ :query ] => [ :environment ] do |_t, args|
      raise 'Please supply required arguments [query]. harvest_by_query["layer_slug_s:*"]' unless args[:query]
      query = args[:query]
      begin
        index = Geoblacklight::SolrDocument.index
        results = index.send_and_receive(index.blacklight_config.solr_path,
                                         q: query,
                                         fl: "*",
                                         rows: 100_000_000)
        num_found = results.response[:numFound]
        doc_counter = 0
        results.docs.each do |document|
          doc_counter += 1
          puts "#{document[:layer_slug_s]} (#{doc_counter}/#{num_found})"
          GeoblacklightSidecarImages::StoreImageJob.perform_later(document.id)
        rescue Blacklight::Exceptions::RecordNotFound
          next
        end
      end
    end
  end
end
