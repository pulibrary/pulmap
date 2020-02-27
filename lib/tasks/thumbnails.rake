# frozen_string_literal: true

namespace :pulmap do
  namespace :thumbnails do
    desc 'Delete all cached thumbnails'
    task delete: :environment do
      Rails.cache.clear
    end
    desc 'Pre-cache a thumbnail'
    task :precache, %i[doc_id override_existing] => [:environment] do |_t, args|
      raise 'Please supply required argument [document_id]' unless args[:doc_id]
      document = Geoblacklight::SolrDocument.find(args[:doc_id])
      raise Blacklight::Exceptions::RecordNotFound if document[:layer_slug_s] != args[:doc_id]
      if !Rails.cache.exist?("thumbnails/#{args[:doc_id]}") || args[:override_existing]
        CacheThumbnailJob.perform_later(document.to_h)
      end
    end

    desc 'Pre-cache all thumbnails'
    task :precache_all, [:override_existing] => [:environment] do |_t, args|
      query = "layer_slug_s:*"
      layers = 'layer_slug_s, layer_id_s, dc_rights_s, dct_provenance_s, layer_geom_type_s, dct_references_s'
      index = Geoblacklight::SolrDocument.index
      results = index.send_and_receive(index.blacklight_config.solr_path,
                                       q: query,
                                       fl: layers,
                                       rows: 100_000_000)
      num_found = results.response[:numFound]
      doc_counter = 0
      results.docs.each do |document|
        doc_counter += 1
        puts "#{document[:layer_slug_s]} (#{doc_counter}/#{num_found})"
        begin
          if !Rails.cache.exist?("thumbnails/#{document[:layer_slug_s]}") || args[:override_existing]
            CacheThumbnailJob.perform_later(document.to_h)
          end
        rescue Blacklight::Exceptions::RecordNotFound
          next
        end
      end
    end

    desc 'Pre-cache all thumbnails for an institution'
    task :precache_institution, %i[institution override_existing] => [:environment] do |_t, args|
      raise 'Please supply required arguments [institution]' unless args[:institution]
      query = "dct_provenance_s:#{args[:institution]}"
      layers = 'layer_slug_s, layer_id_s, dc_rights_s, dct_provenance_s dct_references_s'
      index = Geoblacklight::SolrDocument.index
      results = index.send_and_receive(index.blacklight_config.solr_path,
                                       q: query,
                                       fl: layers,
                                       rows: 100_000_000)
      num_found = results.response[:numFound]
      doc_counter = 0
      results.docs.each do |document|
        doc_counter += 1
        puts "#{document[:layer_slug_s]} (#{doc_counter}/#{num_found})"
        begin
          if !Rails.cache.exist?("thumbnails/#{document[:layer_slug_s]}") || args[:override_existing]
            CacheThumbnailJob.perform_later(document.to_h)
          end
        rescue Blacklight::Exceptions::RecordNotFound
          next
        end
      end
    end
  end
end
