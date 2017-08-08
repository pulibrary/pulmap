Blacklight.onLoad(function() {
  function updatePage(url) {
    $.get(url).done(function(data) {
      var resp = $.parseHTML(data);
      $doc = $(resp);
      $('#documents').replaceWith($doc.find('#documents'));
      $('#index-pagination').replaceWith($doc.find('#index-pagination'));
      $('#sortAndPerPage').replaceWith($doc.find('#sortAndPerPage'));
      $('#facet-view').replaceWith($doc.find('#facet-view'));
      if ($('#appliedParams').length) {
        $('#appliedParams').replaceWith($doc.find('#appliedParams'));
      } else {
        $('#content').prepend($doc.find('#appliedParams'));
      }
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

  $('[data-map="index"]').each(function(i, element) {
    var data = $(this).data(),
        opts = { baseUrl: data.catalogPath }.
        bbox;

    var lngRe = '(-?[0-9]{1,3}(\\.[0-9]+)?)';
    var latRe = '(-?[0-9]{1,2}(\\.[0-9]+)?)';

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
          L.bboxToBounds("-180 -90 180 90");
        }
      });
    }

    var filter_params = L.Control.GeoSearch.prototype.filterParams();

    // Set bbox to default value if bbox is empty or there are no filter params
    if ((typeof bbox === 'undefined') || (filter_params.length === 0)) {
      bbox = L.latLngBounds([[-20, -100],[45, 100]]);
    }

    GeoBlacklight.Home = new GeoBlacklight.Viewer.Map(this, { bbox: bbox });

    // Remove initial overlay
    GeoBlacklight.Home.removeBoundsOverlay();
    L.control.geosearch(opts).addTo(GeoBlacklight.Home.map);

    // set hover listeners on map
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
