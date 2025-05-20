# frozen_string_literal: true

require "rails_helper"

describe CatalogController, type: :controller do
  describe "#has_search_parameters?" do
    subject { controller.has_search_parameters? }

    describe "empty q value" do
      before { allow(controller).to receive_messages(params: { q: nil }) }
      it { is_expected.to be false }
    end
  end

  describe "#after_sign_in_path_for" do
    context "when omniauth.origin is not set" do
      it "redirects to the root path" do
        mock_request = instance_double(ActionDispatch::Request, env: {})
        controller.instance_eval { @request = mock_request }
        expect(controller.after_sign_in_path_for(nil)).to eq "/"
      end
    end
  end
end
