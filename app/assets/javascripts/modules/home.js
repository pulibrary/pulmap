Blacklight.onLoad(function() {
  $('[data-map="home"]').each(function(i, element) {
    var bbox, indexMap;
	bbox = L.latLngBounds([[47.2, -5.6],[49.1, 6.9]]);
    indexMap = new GeoBlacklight.Viewer.Map(this, { bbox: bbox });

    // Remove zoon control
    indexMap.map.zoomControl.removeFrom(indexMap.map)

    // Disable interactivity
    indexMap.map._handlers.forEach(function(handler) {
      handler.disable();
	});
  });
});
