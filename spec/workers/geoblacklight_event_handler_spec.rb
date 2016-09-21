require 'rails_helper'

RSpec.describe GeoblacklightEventHandler do
  subject(:handler) { described_class.new }

  describe '#work' do
    let(:processor) { instance_double(GeoblacklightEventProcessor, process: process) }
    let(:process) {}
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
      let(:process) { true }

      it 'sends the message to the GeoblacklightEventProcessor as a hash' do
        allow(GeoblacklightEventProcessor).to receive(:new).and_return(processor)
        handler.work(msg.to_json)
        expect(processor).to have_received(:process)
        expect(GeoblacklightEventProcessor).to have_received(:new).with(msg)
        expect(handler).to have_received(:ack!)
      end
    end

    context 'when processing is fails' do
      let(:process) { false }

      it 'rejects the message' do
        allow(GeoblacklightEventProcessor).to receive(:new).and_return(processor)
        handler.work(msg.to_json)
        expect(processor).to have_received(:process)
        expect(GeoblacklightEventProcessor).to have_received(:new).with(msg)
        expect(handler).to have_received(:reject!)
      end
    end
  end
end
