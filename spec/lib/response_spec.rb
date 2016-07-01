require 'rails_helper'

describe Pulmap::Suggest::Response do
  let(:empty_response) { described_class.new({}, q: 'hello') }
  let(:response) do
    described_class.new(
      {
        'responseHeader' => {
          'status' => 0,
          'QTime' => 42
        },
        'suggest' => {
          'mySuggester' => {
            'pr' => {
              'numFound' => 2,
              'suggestions' => [
                {
                  'term' => 'princeton',
                  'weight' => 3,
                  'payload' => ''
                },
                {
                  'term' => 'statistics',
                  'weight' => 1,
                  'payload' => ''
                }
              ]
            }
          }
        }
      },
      q: 'pr'
    )
  end

  describe '#initialize' do
    it 'creates a Pulmap::Suggest::Response' do
      expect(empty_response).to be_an described_class
    end
  end
  describe '#suggestions' do
    it 'returns an array of suggestions' do
      expect(response.suggestions).to be_an Array
      expect(response.suggestions.count).to eq 2
      expect(response.suggestions.first['term']).to eq 'princeton'
    end
  end
end
