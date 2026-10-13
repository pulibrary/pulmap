# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "#from_omniauth" do
    subject(:user) do
      described_class.from_omniauth(OpenStruct.new(provider: "openid_connect", uid: "testuser@princeton.edu"))
    end

    it "creates a user" do
      token = double("token", provider: "openid_connect", uid: "test@princeton.edu")
      user = described_class.from_omniauth(token)
      expect(user.uid).to eq "test"
      expect(user.provider).to eq "openid_connect"
      expect(user.email).to eq "test@princeton.edu"
    end

    it "updates an old CAS user" do
      user = FactoryBot.create(:user, provider: "cas")
      token = double("token", provider: "openid_connect", uid: user.email)

      described_class.from_omniauth(token)

      user = User.find(user.id)
      expect(user.provider).to eq "openid_connect"
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
