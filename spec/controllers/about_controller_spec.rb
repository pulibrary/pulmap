# frozen_string_literal: true
require "rails_helper"

describe AboutController, type: :controller do
  describe "The About Us Controller" do
    it "returns a successful index page" do
      get :index
      assert_response :success
    end
  end
end
