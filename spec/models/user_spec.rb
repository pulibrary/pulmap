# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "#from_omniauth" do
    subject(:user) do
      described_class.from_omniauth(OpenStruct.new(provider: "cas", uid: "testuser"))
    end

    it "returns a user" do
      expect(user.uid).to eq("testuser")
    end
  end

  describe "#admin?" do
    context "with an admin user" do
      it "returns true" do
        user = FactoryBot.create(:admin)
        expect(user.admin?).to be true
      end
    end

    context "with a non-admin user" do
      it "returns false" do
        user = FactoryBot.create(:user)
        expect(user.admin?).to be false
      end
    end
  end
end
