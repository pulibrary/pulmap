Blacklight.onLoad(function() {
  $('[data-map="home"]').each(function(i, element) {
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
  });
});
