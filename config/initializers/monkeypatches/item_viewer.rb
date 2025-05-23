# frozen_string_literal: true

# Overridden from:
# https://github.com/geoblacklight/geoblacklight/blob/main/lib/geoblacklight/item_viewer.rb
# Adds methods for `cog` and `pmtiles` layers.
# If this work is merged upstream, this file can be removed.
module Geoblacklight
  class ItemViewer
    def initialize(references)
      @references = references
    end

    def viewer_protocol
      return "map" if viewer_preference.nil?
      viewer_preference.keys.first.to_s
    end

    def viewer_endpoint
      return "" if viewer_preference.nil?
      viewer_preference.values.first.to_s
    end

    def wms
      @references.wms
    end

    def iiif
      @references.iiif
    end

    def tiled_map_layer
      @references.tiled_map_layer
    end

    def dynamic_map_layer
      @references.dynamic_map_layer
    end

    def feature_layer
      @references.feature_layer
    end

    def image_map_layer
      @references.image_map_layer
    end

    def index_map
      @references.index_map
    end

    def oembed
      @references.oembed
    end

    def tms
      @references.tms
    end

    def xyz
      @references.xyz
    end

    def tilejson
      @references.tilejson
    end

    def wmts
      @references.wmts
    end

    def cog
      @references.cog
    end

    def pmtiles
      @references.pmtiles
    end

    def viewer_preference
      [ cog, pmtiles, oembed, index_map, tilejson, xyz, wmts, tms, wms, iiif, tiled_map_layer, dynamic_map_layer,
       image_map_layer, feature_layer ].compact.map(&:to_hash).first
    end
  end
end
