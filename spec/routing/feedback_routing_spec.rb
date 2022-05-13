# frozen_string_literal: true

require "rails_helper"

describe "Feedback Routing", type: :routing do
  describe "routing" do
    it "/feedback routes to a new form" do
      expect(get: "/contact-us").to route_to("feedback#new")
    end

    it "/contact-us posts to create" do
      expect(post: "/contact-us").to route_to("feedback#create")
    end
  end
end
