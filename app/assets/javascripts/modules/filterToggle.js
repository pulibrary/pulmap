$(document).ready(function(){
    $(".facets-toggler").click(function(){
        $("#facets.collapse").collapse('toggle');
        $(".text").text(function(i,old){
            return old=='More Filters' ?  'Less Filters' : 'More Filters';
        });
        $(".facets-toggler .glyphicon").toggleClass('glyphicon-triangle-bottom glyphicon-triangle-right');
    });

    $("#map-container").css({'height':($("#main-container").height())});
    $("#map-results").css({'height':($("#main-container").height())});

    $('.btn-toggle').click(function() {
        $(this).find('.btn').toggleClass('active');
        $(this).find('.btn').toggleClass('btn-primary');
        $(this).find('.btn').toggleClass('btn-default');
        $(".leaflet-container").toggleClass('active');
    });

});