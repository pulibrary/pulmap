$(document).ready(function() {

  $('#map-container').hide();
  $('#map-toggle').on('click', function() {
    $('#facets .facet-view, #facets #map-container').toggle();
    $('.map-toggle').text(function(i, old) {
      return old === 'Turn Map On' ? 'Turn Map Off' : 'Turn Map On';
    });
    $('#side-content').toggleClass('map-view');
    $('#content').toggleClass('map-view');
  });
});
