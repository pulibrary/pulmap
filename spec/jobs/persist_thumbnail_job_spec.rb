require 'rails_helper'

describe PersistThumbnailJob do
  subject(:job) { described_class }

  let(:options) {}
  let(:persist) { instance_double(PersistThumbnail) }

  describe '#perform' do
    it 'calls create_file on a new PersistThumbnail class' do
      allow(PersistThumbnail).to receive(:new).and_return(persist)
      allow(persist).to receive(:create_file)
      job.perform_now(options)
      expect(persist).to have_received(:create_file)
    end
  end
end
