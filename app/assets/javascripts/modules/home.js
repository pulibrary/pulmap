Blacklight.onLoad(function() {
  function updatePage(url) {
    $.get(url).done(function(data) {
      var resp = $.parseHTML(data);
      $doc = $(resp);
      $('#content').replaceWith($doc.find('#content'));
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
        opts = { baseUrl: data.catalogPath };

    GeoBlacklight.Home = new GeoBlacklight.Viewer.Map(this);
    L.control.geocoder('search-gczeV3H', {
      placeholder: 'Find location',
      markers: true,
      pointIcon: false,
      polygonIcon: false,
      expanded: true,
      params: {
        sources: ['whosonfirst']
      }
    }).addTo(GeoBlacklight.Home.map);

    L.control.geosearch(opts).addTo(GeoBlacklight.Home.map);
  });
});
