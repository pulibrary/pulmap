require 'rails_helper'

describe PersistThumbnailJob do
  subject(:job) { described_class }
  let(:options) {}
  let(:persist) { instance_double(PersistThumbnail) }

  describe '#perform' do
    it 'calls create_file on a new PersistThumbnail class' do
      expect(PersistThumbnail).to receive(:new).and_return(persist)
      expect(persist).to receive(:create_file)
      job.perform_now(options)
    end
  end
end
