require 'rails_helper'

RSpec.describe GeoblacklightEventProcessor do
  subject(:processor) { described_class.new(event) }
  let(:resource) { Blacklight.default_index.connection.get('select', params: params) }
  let(:params) { { q: "layer_slug_s:#{RSolr.solr_escape(id)}" } }
  let(:id) { 'objectid' }
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
      'layer_slug_s' => id,
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
      params = { q: "layer_slug_s:#{RSolr.solr_escape(id)}" }
      resource = Blacklight.default_index.connection.get('select', params: params)
      expect(resource['response']['docs'].first['layer_slug_s']).to eq(id)
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
      expect(processor.process).to eq true
      expect(resource['response']['docs'].length).to eq(0)
    end
  end
end
