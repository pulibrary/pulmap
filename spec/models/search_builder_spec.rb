# frozen_string_literal: true

require 'rails_helper'

describe SearchBuilder do
  subject(:builder) { search_builder.with(user_params) }

  let(:user_params) { {} }
  let(:solr_params) { {} }
  let(:context) { CatalogController.new }
  let(:search_builder) { described_class.new(context) }

  describe '#add_spatial_params' do
    it 'returns the solr_params when no bbox is given' do
      expect(builder.add_spatial_params(solr_params)).to eq solr_params
    end

    it 'returns the solr_params when bbox is incorrectly formatted' do
      params = { bbox: '-380 -80' }
      builder.with(params)
      expect(builder.add_spatial_params(solr_params)).to eq solr_params
    end
  end

  describe '#add_featured_content' do
    it 'returns search for sanborn records when featured param is set to sanborn' do
      params = { featured: 'sanborn' }
      builder.with(params)
      expect(builder.add_featured_content(solr_params)[:fq].to_s).to include('dc_title_s:*Sanborn')
    end

    it 'returns search for scanned maps when featured param is set to scanned_maps' do
      params = { featured: 'scanned_maps' }
      builder.with(params)
      expect(builder.add_featured_content(solr_params)[:fq].to_s).to include('-dc_title_s:*Sanborn')
    end

    it 'returns search for raster datasets when featured param is set to raster' do
      params = { featured: 'raster' }
      builder.with(params)
      expect(builder.add_featured_content(solr_params)[:fq].to_s).to include('Raster')
    end

    it 'returns search for vector datasets when featured param is set to vector' do
      params = { featured: 'vector' }
      builder.with(params)
      expect(builder.add_featured_content(solr_params)[:fq].to_s).to include('Polygon')
    end
  end
end
