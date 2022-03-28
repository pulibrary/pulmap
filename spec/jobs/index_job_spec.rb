# frozen_string_literal: true
require "rails_helper"

describe IndexJob do
  describe "#perform" do
    let(:msg) do
      {
        'event' => 'CREATED'
      }
    end
    let(:processor) { instance_double(GeoblacklightEventProcessor) }

    before do
      allow(GeoblacklightEventProcessor).to receive(:new).and_return(processor)
      allow(processor).to receive(:process)
    end

    it "calls processes the message" do
      described_class.perform_now(msg)
      expect(GeoblacklightEventProcessor).to have_received(:new).with(msg)
      expect(processor).to have_received(:process)
    end
  end
end
