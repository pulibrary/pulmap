!function(global) {
  "use strict";

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
        this.pushStateSearcher();
      },
      delay: 800,
      staticButton: '<a class="btn btn-primary">Search here <i class="fa fa-repeat" aria-hidden="true"></i></a>',
      dynamicButton: '<label><input type="checkbox" checked> Search when I move the map</label>'
    },

    initialize: function(options) {
      L.Util.setOptions(this, options);
      this.$staticButton = $(this.options.staticButton);
      this.$dynamicButton = $(this.options.dynamicButton);
    },

    onAdd: function(map) {
      var $container = $('<div class="leaflet-control search-control"></div>'),
          staticSearcher, dynamicSearcher;
      this._map = map;

      staticSearcher = L.Util.bind(function() {
        this.$staticButton.hide();
        this.$dynamicButton.show();
        this.options.searcher.apply(this);
      }, this);
  
      dynamicSearcher = GeoBlacklight.debounce(function() {
        if (GeoBlacklight.supressDynamicSearch === true) {
          GeoBlacklight.supressDynamicSearch = false;
        } else if (this.options.dynamic) {
          GeoBlacklight.supressDynamicSearch = true;
          this.options.searcher.apply(this);
        }
      }, this.options.delay);

      this.$staticButton.on('click', staticSearcher);
      $( "#map-search-facet" ).on('click', staticSearcher);

      $container.on("change", "input[type=checkbox]",
        L.Util.bind(function() {
          this.options.dynamic = !this.options.dynamic;
        }, this)
      );

      if (this.options.dynamic) {
        this.$staticButton.hide();
      } else {
        this.$dynamicButton.hide();
      }

      // Don't trigger dynamic search on resize event
      map.on("resize", function() {
        GeoBlacklight.supressDynamicSearch = true;
      }, this);

      // Trigger a map move after a geocoder location has been selected. A workaround
      // for an issue with supressing the dynamic search on inital load.
      map.on("geosearch/showlocation", function(event) {
        event.target.fitBounds(event.location.bounds)
      });

      // Trigger dynamic search on map move
      map.on("moveend", function(event) {
        if (GeoBlacklight.supressDynamicSearch === true) {
          // Supresses dynamic search and reset flag
          GeoBlacklight.supressDynamicSearch = false;
        } else {
          // Trigger dynamic search
          dynamicSearcher.apply(this);
        }
      }, this);

      $container.append(this.$staticButton, this.$dynamicButton);
      return $container.get(0);
    },

    static_searcher: function(){
      window.location.href = this.getSearchUrl();
    },

    pushStateSearcher: function() {
      History.pushState(null, document.title, this.getSearchUrl());
    },

    getSearchUrl: function() {
      var params = this.filterParams(['bbox', 'page']),
          bounds = L.boundsToBbox(this._map.getBounds());

      params.push('bbox=' + encodeURIComponent(bounds.join(' ')));
      return this.options.baseUrl + '?' + params.join('&');
    },

    filterParams: function(filterList) {
      var querystring = window.location.search.substr(1),
          params = [];

      if (querystring !== "") {
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
