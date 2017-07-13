Blacklight.onLoad(function() {
  $('[data-map="home"]').each(function(i, element) {
    var bbox;
    bbox = L.latLngBounds([[77, 180],[-47, -180]]);
    GeoBlacklight.Home = new GeoBlacklight.Viewer.Map(this, { bbox: bbox });
  });
});
