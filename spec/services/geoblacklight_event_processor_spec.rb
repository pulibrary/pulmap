require 'rails_helper'

RSpec.describe GeoblacklightEventProcessor do
  subject(:processor) { described_class.new(event) }
  let(:resource) { Blacklight.default_index.connection.get('select', params: params) }
  let(:params) { { q: "uuid:#{RSolr.solr_escape(id)}" } }
  let(:id) { 'http://purl.stanford.edu/dp018hs9766' }
  let(:title) { 'geo title' }
  let(:event) do
    {
      'id' => id,
      'event' => type,
      'doc' => geoblacklight_document
    }
  end
  let(:geoblacklight_document) do
    {
      'uuid' => id,
      'dc_title_s' => title
    }
  end

  context 'when given an unknown event' do
    let(:type) { 'UNKNOWNEVENT' }
    it 'returns false' do
      expect(processor.process).to eq false
    end
  end

  context 'when given a creation event with an invalid document' do
    let(:type) { 'CREATED' }
    let(:geoblacklight_document) { { 'dc_title_s' => title } }
    it 'returns false' do
      expect(processor.process).to eq false
    end
  end

  context 'when given a creation event with an valid document' do
    let(:type) { 'CREATED' }
    it 'adds the geoblacklight document' do
      expect(processor.process).to eq true
      params = { q: "uuid:#{RSolr.solr_escape(id)}" }
      resource = Blacklight.default_index.connection.get('select', params: params)
      expect(resource['response']['docs'].first['uuid']).to eq(id)
    end
  end

  context 'when given an update event' do
    let(:type) { 'UPDATED' }
    let(:title) { 'updated geo title' }
    it 'updates that resource' do
      expect(processor.process).to eq true
      expect(resource['response']['docs'].first['dc_title_s']).to eq(title)
    end
  end

  context 'when given a delete event' do
    let(:type) { 'DELETED' }
    it 'deletes that resource' do
      connection = Blacklight.default_index.connection
      num_docs = connection.get('select')['response']['docs'].length
      expect(processor.process).to eq true
      expect(connection.get('select')['response']['docs'].length).to eq(num_docs - 1)
    end
  end
end
