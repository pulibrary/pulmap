require 'rails_helper'

RSpec.describe FeedbackForm do
  let(:feedback) { described_class.new(params) }
  let(:params) do
    { name: 'Bob Smith',
      email: 'bsmith@university.edu',
      message: 'Awesome Site!!!!' }
  end
  describe 'A vaild Feedback Email' do
    it 'is valid' do
      expect(feedback.valid?).to be_truthy
    end

    it 'Can deliver a message' do
      expect(feedback).to respond_to(:deliver)
    end

    context 'It has invalid data' do
      let(:params) do
        { name: 'Bar',
          email: 'foo',
          message: nil }
      end
      it 'is invalid' do
        expect(feedback.valid?).to be_falsey
      end
    end
  end

  describe '#headers' do
    it 'returns mail headers' do
      expect(feedback.headers).to be_truthy
    end

    it "Contains the submitter's email address" do
      expect(feedback.headers[:from]).to eq('"Bob Smith" <bsmith@university.edu>')
    end
  end

  describe 'error_message' do
    it 'returns the configured error string' do
      expect(feedback.error_message).to eq(I18n.t('blacklight.feedback.error'))
    end
  end
end
