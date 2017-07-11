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
        $('#main-container').prepend($doc.find('#appliedParams'));
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

  $('[data-map="home"]').each(function(i, element) {
    var data = $(this).data(),
        opts = { baseUrl: data.catalogPath };

    GeoBlacklight.Home = new GeoBlacklight.Viewer.Map(this);
    L.control.geocoder('search-gczeV3H', {
      placeholder: 'Near a location',
      markers: true,
      pointIcon: false,
      polygonIcon: false,
      expanded: true,
      params: {
        sources: ['whosonfirst']
      }
    }).addTo(GeoBlacklight.Home.map);

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
