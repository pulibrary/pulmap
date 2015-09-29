Blacklight.onLoad(function() {
  $('[data-map="home"]').each(function(i, element) {

    var geoblacklight = new GeoBlacklight.Viewer.Map(this),
        data = $(this).data();
    geoblacklight.map.addControl(L.control.geosearch({
      baseUrl: data.catalogPath,
      dynamic: false,
      bindToMap: false,
      container: $('#geosearch'),
      searcher: function() {
        window.location.href = this.getSearchUrl();
      },
      // staticButton: button,
      staticButton: '<button type="button" class="btn btn-primary search-btn">Search Map Area</button>'
    }));
  });
});
