require 'rails_helper'

describe ApplicationController do
  describe '#after_sign_in_path_for' do
    subject { controller.send(:after_sign_in_path_for, nil) }

    context 'with an empty referer' do
      it 'returns the root path' do
        expect(subject).to eq('/')
      end
    end
  end
end
