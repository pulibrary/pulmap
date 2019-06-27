Blacklight.onLoad(function() {
  var historySupported = !!(window.history && window.history.pushState);

  if (historySupported) {
    History.Adapter.bind(window, 'statechange', function() {
      var state = History.getState();
      updatePage(state.url);
    });
  }

  $('[data-map="index"]').each(function(i, element) {
    var data = $(this).data(),
        opts = { baseUrl: data.catalogPath }.
        bbox = initialBoundingBox(data);

    // Instantiate new map
    GeoBlacklight.Home = new GeoBlacklight.Viewer.Map(this, { bbox: bbox });

    // Add geocoder
    addGeocoder(GeoBlacklight.Home.map)

    // Remove initial overlay
    GeoBlacklight.Home.removeBoundsOverlay();

    // Add geosearch control
    L.control.geosearch(opts).addTo(GeoBlacklight.Home.map);

    // Set document markers
    placeMarkers();

    // Set hover listeners
    setHoverListeners();
  });

  function initialBoundingBox(data) {
    var world = L.latLngBounds([[-90, -180], [90, 180]]);
    var filter_params = L.Control.GeoSearch.prototype.filterParams();

    if (typeof data.mapBbox === 'string') {
      GeoBlacklight.supressDynamicSearch = false; // Ensures that dynamic search is triggered
      bbox = L.bboxToBounds(data.mapBbox);
    } else {
      GeoBlacklight.supressDynamicSearch = false; // Ensures that dynamic search is triggered
      $('.document [data-bbox]').each(function() {

        try {
          var currentBounds = L.bboxToBounds($(this).data().bbox);
          if (!world.contains(currentBounds)) {
            throw "Invalid bounds";
          }
          if (typeof bbox === 'undefined') {
            bbox = currentBounds;
          } else {
            bbox.extend(currentBounds);
          }
        } catch (e) {
          bbox = L.bboxToBounds("-180 -90 180 90");
        }
      });
    }

    // Set bbox to default value if bbox is empty or there are no filter params
    if ((typeof bbox === 'undefined') || (filter_params.length === 0)) {
      bbox = L.latLngBounds([[-20, -100],[45, 100]]);
    }

    return bbox;
  }

  function placeMarkers() {
    // Clear existing markers
    GeoBlacklight.Home.removeMarkers();

    $('.document [data-bbox]').each(function() {
      var _this = $(this),
          currentBbox = _this.data().bbox,
          layerId = _this.data().layerId;
          counter = _this.data().counter + 1,
          redMarker = L.ExtraMarkers.icon({
            innerHTML: '<p style="color: white; margin-top: 8px;">' + counter + '</p>',
            markerColor: 'blue',
            shape: 'square',
            prefix: 'fa'
          });

      if (currentBbox) {
        var bounds = L.bboxToBounds(currentBbox);
        var marker = L.marker(bounds.getCenter(), {icon: redMarker});

        // Add marker to map
        marker.addTo(GeoBlacklight.Home.markers);

        // Set scroll click event on marker
        marker.on('click', function() {
          $( ".document .selected" ).removeClass( "selected" );
          $('html, body').animate({scrollTop: _this.offset().top - 120}, 200);
          $( _this ).addClass( "selected" );
        });
      }
    });
  }

  function setHoverListeners() {
    $('[data-map="index"]').each(function(i, element) {
      $('#content')
        .on('mouseenter', '#documents [data-layer-id]', function() {
          var bounds = L.bboxToBounds($(this).data('bbox'));
          GeoBlacklight.Home.addBoundsOverlay(bounds);
        })
        .on('mouseleave', '#documents [data-layer-id]', function() {
          GeoBlacklight.Home.removeBoundsOverlay();
      });
    });
  }

  /**
   * Add a geocoding plugin to the map
   * @param {L.Map} map Leaflet Map instance
   */
  function addGeocoder(map) {
    window.geoCoder.addTo(map);

    var options = {
      placement: 'bottom',
      delay: { "show": 1000, "hide": 100 },
      container: 'body',
      title: 'Zoom map to location'
    };

    // Set tooltips on geocoder
    $('.geosearch a.leaflet-bar-part-single').attr('data-toggle','tooltip');
    $('.geosearch a.leaflet-bar-part-single').tooltip(options);
  }

  function updatePage(url) {
    $( ".overlay" ).fadeIn( 100 );

    $.get(url).done(function(data) {
      var resp = $.parseHTML(data);
      $doc = $(resp);

      // Reload content
      $('#content').replaceWith($doc.find('#content'));

      // Append hidden bbox seach input to improve push state search behavior
      if ($('form.search-query-form.form-inline.home-search.navbar-form').find('input[name=bbox]').length) {
        $('input[name=bbox]')[0].replaceWith($doc.find('input[name=bbox]')[0])
      } else {
        $('form.search-query-form.form-inline.home-search.navbar-form').prepend($doc.find('input[name=bbox]')[0])
      }

      // Reload thumbnail images
      aload();

      // Reload markers and listeners
      placeMarkers();
      setHoverListeners();

      // Allow interaction with results
      $( ".overlay" ).fadeOut( 500 );
    });
  }
});
