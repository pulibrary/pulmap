# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SidekiqChart do
  let(:stats) { instance_double(Sidekiq::Stats, enqueued: 100, processed: 50, failed: 3) }
  let(:retry_set) { instance_double(Sidekiq::RetrySet, size: 2) }
  let(:dead_set) { instance_double(Sidekiq::DeadSet, size: 1) }
  let(:workers) { instance_double(Sidekiq::Workers, size: 5) }

  before do
    allow(Sidekiq::Stats).to receive(:new).and_return(stats)
    allow(Sidekiq::RetrySet).to receive(:new).and_return(retry_set)
    allow(Sidekiq::DeadSet).to receive(:new).and_return(dead_set)
    allow(Sidekiq::Workers).to receive(:new).and_return(workers)
  end

  describe "#render" do
    subject { described_class.new.render }

    it { is_expected.to include("Busy      5") }
    it { is_expected.to include("Enqueued    100") }
    it { is_expected.to include("Processed     50") }
    it { is_expected.to include("Failed      3") }
    it { is_expected.to include("Retries      2") }
    it { is_expected.to include("Dead      1") }
  end
end
