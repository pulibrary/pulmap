require 'rails_helper'

describe SearchBuilder do
  let(:user_params) { Hash.new }
  let(:solr_params) { Hash.new }
  let(:blacklight_config) { CatalogController.blacklight_config.deep_copy }
  let(:context) { CatalogController.new }

  let(:search_builder) { described_class.new(context) }

  subject { search_builder.with(user_params) }

  describe '#add_spatial_params' do
    it 'returns the solr_params when no bbox is given' do
      expect(subject.add_spatial_params(solr_params)).to eq solr_params
    end

    context 'when a bbox is given' do
      params = { bbox: '-180 -80 120 80' }

      it 'returns a spatial search with ' do
        subject.with(params)
        expect(subject.add_spatial_params(solr_params)[:fq].to_s)
          .to include('Intersects')
        expect(subject.add_spatial_params(solr_params)[:bq].to_s)
          .to match(/.*IsWithin.*\^300/)
      end
    end
  end
end
