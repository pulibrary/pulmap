# frozen_string_literal: true

require "sitemap_generator"

SitemapGenerator::Sitemap.default_host = if Rails.env.production?
                                           "https://maps.princeton.edu"
                                         else
                                           "http://localhost"
                                         end

SitemapGenerator::Sitemap.create do
  add "/advanced"
  add "/contact-us"

  cursor_mark = "*"
  loop do
    response = Blacklight.default_index.connection.get("select", params:
    {
      "q" => "dct_provenance_s:Princeton",
      "fl" => "layer_slug_s",
      "cursorMark" => cursor_mark,
      "rows" => ENV["BATCH_SIZE"] || 1000,
      "sort" => "layer_slug_s asc"
    })

    response["response"]["docs"].each do |doc|
      add "/catalog/#{doc['layer_slug_s']}"
    end

    break if response["nextCursorMark"] == cursor_mark
    cursor_mark = response["nextCursorMark"]
  end
end
