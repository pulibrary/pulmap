Blacklight.onLoad(function() {
  function updatePage(url) {
    $.get(url).done(function(data) {
      var resp = $.parseHTML(data);
      $doc = $(resp);
      $('#search-bar-container').replaceWith($doc.find('#search-bar-container'));
      $('#documents').replaceWith($doc.find('#documents'));
      $('#index-pagination').replaceWith($doc.find('#index-pagination'));
      $('#sortAndPerPage').replaceWith($doc.find('#sortAndPerPage'));
      $('#facet-view').replaceWith($doc.find('#facet-view'));
      if ($('#map').next().length) {
        $('#map').next().replaceWith($doc.find('#map').next());
      } else {
        $('#map').after($doc.find('#map').next());
      }

      // reload thumbnail images
      aload();
    });
  }

  var historySupported = !!(window.history && window.history.pushState);

  if (historySupported) {
    History.Adapter.bind(window, 'statechange', function() {
      var state = History.getState();
      updatePage(state.url);
    });
  }

  $('[data-map="home"]').each(function(i, element) {
    var data = $(this).data(),
        // opts = { baseUrl: data.catalogPath }.
        // bbox;
        opts = { baseUrl: data.catalogPath },
        geoblacklight, bbox;

    var lngRe = '(-?[0-9]{1,2}(\\.[0-9]+)?)';
    var latRe = '(-?[0-9]{1,3}(\\.[0-9]+)?)';

    var parseableBbox = new RegExp(
      [lngRe,latRe,lngRe,latRe].join('\\s+')
    );

    if (typeof data.mapBbox === 'string') {
      bbox = L.bboxToBounds(data.mapBbox);
    } else {
      $('.document [data-bbox]').each(function() {
        var currentBbox = $(this).data().bbox;
        if (parseableBbox.test(currentBbox)) {
          if (typeof bbox === 'undefined') {
            bbox = L.bboxToBounds(currentBbox);
          } else {
            bbox.extend(L.bboxToBounds(currentBbox));
          }
        } else {
          // bbox not parseable, use default value.
          // L.bboxToBounds("-180 -90 180 90");
          bbox = L.latLngBounds([[77, 180],[-47, -180]]);
        }
      });
    }

    GeoBlacklight.Home = new GeoBlacklight.Viewer.Map(this);

    L.control.findloc({ position: 'topleft' }).addTo(GeoBlacklight.Home.map);

    L.control.geocoder('search-gczeV3H', {
      placeholder: 'Zoom to location',
      markers: true,
      pointIcon: false,
      polygonIcon: false,
      expanded: true,
      params: {
        sources: ['whosonfirst']
      }
    }).addTo(GeoBlacklight.Home.map);

    L.control.geosearch(opts).addTo(GeoBlacklight.Home.map);


    $('#content')
      .on('mouseenter', '#documents [data-layer-id]', function() {
        var bounds = L.bboxToBounds($(this).data('bbox'));
        GeoBlacklight.Home.addBoundsOverlay(bounds);
      })
      .on('mouseleave', '#documents [data-layer-id]', function() {
        GeoBlacklight.Home.removeBoundsOverlay();
      });



  });
});
