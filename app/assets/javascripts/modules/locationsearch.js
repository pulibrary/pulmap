Blacklight.onLoad(function() {
  $('[data-map="home"]').each(function(i, element) {
    // map search off by default
    var searchState = false;

    function updateBboxField() {
      var bounds = L.boundsToBbox(GeoBlacklight.Home.map.getBounds());
      $("input[name='bbox']").val(bounds.join(' '));
    }

    function addBboxField() {
      var searchForm = $('.home-search');
      var bboxInput = '<input name="bbox" type="hidden" value="">';
      $(bboxInput).appendTo(searchForm);
      updateBboxField();
    }

    function removeBboxField() {
      $("input[name='bbox']").remove();
    }

    function resetPlaceInput() {
      $("input[type='place']").val('');
    }

    function toggleMapSearch() {
      searchState = !searchState;
      $('.leaflet-container').toggleClass('active');
      if (searchState) {
        addBboxField();
      } else {
        removeBboxField();
      }
    }

    $('.btn-toggle').click(function() {
      toggleMapSearch();
    });

    // hide zoom control on load
    $('.leaflet-control-zoom').toggle();

    // turn on map search and update bbox field on map move
    GeoBlacklight.Home.map.on('moveend', function(e) {
      if (!searchState) {
        toggleMapSearch();
        $('#map-toggle').prop('checked', true).change()
      }
      updateBboxField();
      resetPlaceInput();
    });
  });
});
