$(document).ready(function(){
    $(".facets-toggler").click(function(){
        $("#facets.collapse").collapse('toggle');
    });

    $("#map-container").css({'height':($("#main-container").height())});
    $("#map-results").css({'height':($("#main-container").height())});
});