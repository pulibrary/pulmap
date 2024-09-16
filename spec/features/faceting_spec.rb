# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Faceting", type: :feature do
  it "Faceting on a field that allow multiple values, user can remove that facet value" do
    visit "/?f[dc_subject_sm][]=Statistics&q=Uganda"
    expect(first("a.remove")[:href]).to eq("/?q=Uganda")
  end

  it "User can remove all facets values when faceting on a single value field," do
    visit "/?f[layer_geom_type_sm][]=Polygon&q=Uganda"
    expect(first("a.remove")[:href]).to eq("/?q=Uganda")
  end
end
