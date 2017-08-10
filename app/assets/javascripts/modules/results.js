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
      bbox = L.bboxToBounds(data.mapBbox);
    } else {
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
      var currentBbox = $(this).data().bbox,
          counter = $(this).data().counter + 1,
          redMarker = L.ExtraMarkers.icon({
            innerHTML: '<p style="color: white; margin-top: 8px;">' + counter + '</p>',
            markerColor: 'blue',
            shape: 'square',
            prefix: 'fa'
          });

      if (currentBbox) {
        var bounds = L.bboxToBounds(currentBbox);
        L.marker(bounds.getCenter(), {icon: redMarker}).addTo(GeoBlacklight.Home.markers);
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

  function updatePage(url) {
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
    });
  }
});
