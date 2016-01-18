$(document).ready(function() {
  $('.map-view').hide();
  $('#map-toggle').on('click', function() {
    $('#facets .facet-view, #facets .map-view').toggle();
    $('.map-toggle').text(function(i, old) {
      return old === 'Turn Map On' ? 'Turn Map Off' : 'Turn Map On';
    });
  });
});
