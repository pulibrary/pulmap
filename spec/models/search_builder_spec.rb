require 'rails_helper'

describe SearchBuilder do
  let(:user_params) { Hash.new }
  let(:solr_params) { Hash.new }
  let(:context) { CatalogController.new }
  let(:search_builder) { described_class.new(context) }

  subject(:builder) { search_builder.with(user_params) }

  describe '#add_spatial_params' do
    it 'returns the solr_params when no bbox is given' do
      expect(builder.add_spatial_params(solr_params)).to eq solr_params
    end

    it 'returns the solr_params when bbox is incorrectly formatted' do
      params = { bbox: '-380 -80' }
      builder.with(params)
      expect(builder.add_spatial_params(solr_params)).to eq solr_params
    end

    it 'returns a spatial search using IsWithin if bbox is given' do
      params = { bbox: '-180 -80 120 80' }
      builder.with(params)
      expect(builder.add_spatial_params(solr_params)[:fq].to_s).to include('IsWithin')
    end
  end
end
