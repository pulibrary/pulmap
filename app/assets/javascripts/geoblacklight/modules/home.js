Blacklight.onLoad(function() {
  $('[data-map="home"]').each(function(i, element) {
    GeoBlacklight.Home = new GeoBlacklight.Viewer.Map(this);
  });
});
