$(document).ready(function() {
  $('#map-container').hide();
  $('#map-toggle').on('click', function() {
    $('#facets .facet-view, #facets #map-container').toggle();
    $('.map-toggle').text(function(i, old) {
      return old === 'Map On' ? 'Map Off' : 'Map On';
    });
    $('#side-content').toggleClass('map-view');
    $('#content').toggleClass('map-view');
  });
});
