Blacklight.onLoad(function() {
  var historySupported = !!(window.history && window.history.pushState);
  
  if (historySupported) {
    History.Adapter.bind(window, 'statechange', function() {
      var state = History.getState();
      updatePage(state.url);
    });
  }

  $('[data-map="index"]').each(function() {
    var data = $(this).data(),
    opts = { baseUrl: data.catalogPath },
    geoblacklight, bbox;

    if (typeof data.mapBbox === 'string') {
      bbox = L.bboxToBounds(data.mapBbox);
    } else {
      $('.document [data-bbox]').each(function() {
        if (typeof bbox === 'undefined') {
          bbox = L.bboxToBounds($(this).data().bbox);
        } else {
          bbox.extend(L.bboxToBounds($(this).data().bbox));
        }
      });
    }

    if (!historySupported) {
      $.extend(opts, {
        dynamic: false,
        searcher: function() {
          window.location.href = this.getSearchUrl();
        }
      });
    }

    // instantiate new map
    var geoblacklight = new GeoBlacklight.Viewer.Map(this, { bbox: bbox });

    // set hover listeners on map
    $('#content')
      .on('mouseenter', '#documents [data-layer-id]', function() {
        var bounds = L.bboxToBounds($(this).data('bbox'));
        geoblacklight.addBoundsOverlay(bounds);
      })
      .on('mouseleave', '#documents [data-layer-id]', function() {
        geoblacklight.removeBoundsOverlay();
      });

    // add geosearch control to map
    geoblacklight.map.addControl(L.control.geosearch(opts));
  });

  function updatePage(url) {
    $.get(url).done(function(data) {
      var resp = $.parseHTML(data);
      $doc = $(resp);
      $('#content').replaceWith($doc.find('#content'));
      $('#facet-view').replaceWith($doc.find('#facet-view'));
      $('#appliedParams').replaceWith($doc.find('#appliedParams'));
      if ($('#map').next().length) {
        $('#map').next().replaceWith($doc.find('#map').next());
      } else {
        $('#map').after($doc.find('#map').next());
      }

      // reload thumbnail images
      aload();

      // reload map toggle
      GeoBlacklight.MapToggle.load();
    });
  }
});
