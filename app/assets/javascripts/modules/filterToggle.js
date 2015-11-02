$(document).ready(function() {
    $('.facets-toggler').click(function() {
        $('#facets.collapse').collapse('toggle');
        $('.text').text(function(i, old) {
            return old === 'More Filters' ? 'Less Filters' : 'More Filters';
        });
        $('.facets-toggler .glyphicon').toggleClass('glyphicon-triangle-bottom glyphicon-triangle-right');
    });

    // if($('#table-container').length === 0 ) {
    //   $('#table-container').removeClass('col-md-4');
    //   $('#viewer-container').removeClass('col-md-8');
    // }
});
