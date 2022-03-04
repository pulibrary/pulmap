# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GeoblacklightEventHandler do
  let(:handler) { described_class.new }

  describe '#work' do
    let(:msg) do
      {
        'event' => 'CREATED'
      }
    end

    before do
      allow(handler).to receive(:ack!)
      allow(handler).to receive(:reject!)
    end

    context 'when processing is successful' do
      it 'sends the message to the GeoblacklightEventProcessor as a hash' do
        allow(IndexJob).to receive(:perform_later)
        handler.work(msg.to_json)
        expect(IndexJob).to have_received(:perform_later).with(msg)
        expect(handler).to have_received(:ack!)
      end
    end
  end
end
