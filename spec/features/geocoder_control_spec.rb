require "rails_helper"

describe "Geocoder control", js: true do
  it "renders the location search on the search results map" do
    visit "/catalog?q=new+jersey"

    within ".leaflet-control-container" do
      expect(page).to have_css(".leaflet-control-geosearch a.leaflet-bar-part-single")
    end
  end

  it "opens the location search form when clicked" do
    visit "/catalog?q=new+jersey"

    find(".leaflet-control-geosearch a.leaflet-bar-part-single").click

    expect(page).to have_field(placeholder: "Search for location")
  end
end
