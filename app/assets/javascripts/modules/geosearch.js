!function(global) {
  'use strict';

  /**
   * Convert LatLngBounds to array of values.
   *
   * Additionally, this will wrap the longitude values for the corners.
   * @param {L.LatLngBounds} bounds Leaflet LatLngBounds object
   * @return {Array} Array of values as [sw.x, sw.y, ne.x, ne.y]
   */
  L.boundsToBbox = function(bounds) {
    var sw = bounds.getSouthWest(),
        ne = bounds.getNorthEast();

    if ((ne.lng - sw.lng) >= 360) {
      sw.lng = -180;
      ne.lng = 180;
    }
    sw = sw.wrap();
    ne = ne.wrap();
    return [
      L.Util.formatNum(sw.lng, 6),
      L.Util.formatNum(sw.lat, 6),
      L.Util.formatNum(ne.lng, 6),
      L.Util.formatNum(ne.lat, 6)
    ];
  };

  L.Control.GeoSearch = L.Control.extend({
    options: {
      dynamic: true,
      baseUrl: '',
      searcher: function() {
        History.pushState(null, document.title, this.getSearchUrl());
      },
      delay: 800,
      staticButton: '<a class="btn btn-primary">Redo search here <span class="glyphicon glyphicon-repeat"></span></a>',
      dynamicButton: '<label><input type="checkbox" checked> Search when I move the map</label>'
    },

    initialize: function(options) {
      L.Util.setOptions(this, options);
    },

    onAdd: function(map) {
      var $container = $('<div class="leaflet-control search-control"></div>'),
          dynamicSearcher;
      this._map = map;

      dynamicSearcher = GeoBlacklight.debounce(function() {
        if (this.options.dynamic) {
          this.options.searcher.apply(this);
        }
      }, this.options.delay);

      map.on('zoomend', dynamicSearcher, this);
      map.on('dragend', dynamicSearcher, this);
      map.on('movestart', function() {
        if (!this.options.dynamic) {
          this.$dynamicButton.hide();
          this.$staticButton.show();
        }
      }, this);

      return $container.get(0);
    },

    // Clamps the search bounding box size to a box with a width smaller than a max value.
    // Helps focus spatial searches on large screens.
    searchBounds: function() {
      var max_width = 1000,
          width = this._map.getSize().x,
          padding = (width - max_width) / 2,
          bounds = this._map.getBounds(),
          bbox = L.boundsToBbox(bounds),
          sw_layer = this._map.latLngToLayerPoint(bounds.getSouthWest()),
          ne_layer = this._map.latLngToLayerPoint(bounds.getNorthEast());
      if (width <= max_width) return bbox;
      sw_layer.x = sw_layer.x + padding;
      ne_layer.x = ne_layer.x - padding;
      bbox[0] = this._map.layerPointToLatLng(sw_layer).lng
      bbox[2] = this._map.layerPointToLatLng(ne_layer).lng
      return bbox;
    },

    getSearchUrl: function() {
      var params = this.filterParams(['bbox', 'page']),
          bounds = this.searchBounds();
      params.push('bbox=' + encodeURIComponent(bounds.join(' ')));
      return this.options.baseUrl + '?' + params.join('&');
    },

    filterParams: function(filterList) {
      var querystring = window.location.search.substr(1),
          params = [];

      if (querystring !== '') {
        params = $.map(querystring.split('&'), function(value) {
          if ($.inArray(value.split('=')[0], filterList) > -1) {
            return null;
          } else {
            return value;
          }
        });
      }
      return params;
    }

  });

  L.control.geosearch = function(options) {
    return new L.Control.GeoSearch(options);
  };

}(this);
