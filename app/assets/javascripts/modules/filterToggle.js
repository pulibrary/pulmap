$(document).ready(function() {
  $('.facets-toggler').click(function() {
    $('#facets.collapse').collapse('toggle');
    $('.text').text(function(i, old) {
      return old === 'More Filters' ? 'Less Filters' : 'More Filters';
    });
    $('.facets-toggler .glyphicon').toggleClass('glyphicon-triangle-bottom glyphicon-triangle-right');
  });
});