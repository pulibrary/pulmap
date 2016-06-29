require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#from_omniauth' do
    subject do
      described_class.from_omniauth(OpenStruct.new(provider: 'cas', uid: 'testuser'))
    end

    it 'returns a user' do
      expect(subject.uid).to eq('testuser')
    end
  end
end
