$(document).ready(function() {
  function isScrolledTo(elem) {
    var docViewTop = $(window).scrollTop(); //num of pixels hidden above current screen
    var docViewBottom = docViewTop + $(window).height();
    var elemTop = $(elem).offset().top; //num of pixels above the elem
    var elemBottom = elemTop + $(elem).height();
    console.log("Elem Bottom: "+elemBottom);
    console.log("Return: "+ (elemTop <= docViewTop));
    return ((elemTop <= docViewTop || elemTop >= docViewTop));
  }
  var catcher = $('header');
  var sticky = $('#map-container');
  var footer = $('footer');
  var footTop = footer.offset().top;
  var lastStickyTop = sticky.offset().top;
  $(window).scroll(function() {
    if(isScrolledTo(sticky)) {
      sticky.css('position','fixed');
      sticky.css('top','20px');
    }
    var stopHeight = catcher.offset().top + catcher.height();
    var stickyFoot = sticky.offset().top + sticky.height();

    if(stickyFoot > footTop -10){
      console.log("Top of Footer");
      sticky.css({
        position:'absolute',
        top: (footTop - 20) - sticky.height()
      });
    } else {
      if ( stopHeight > sticky.offset().top) {
        console.log("Default position");
        sticky.css('position','absolute');
        sticky.css('top',stopHeight);
      }
    }
  });
});