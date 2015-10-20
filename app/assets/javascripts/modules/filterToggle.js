$(document).ready(function(){
    $(".facets-toggler").click(function(){
        $("#facets.collapse").collapse('toggle');
        $(this).text(function(i,old){
            return old=='More Filters' ?  'Less Filters' : 'More Filters';
        });
    });

    $("#map-container").css({'height':($("#main-container").height())});
    $("#map-results").css({'height':($("#main-container").height())});
});