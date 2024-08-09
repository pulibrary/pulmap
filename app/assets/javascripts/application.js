// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require twitter/typeahead
//= require aload

// Required by Blacklight
//= require popper
//= require bootstrap
//= require blacklight/blacklight
//= require 'blacklight_range_limit'

//= require modernizr
//= require handlebars.runtime

//= require_tree .

//= stub modules/results
//= require modules/map
//= require modules/thumbnail
//= require modules/autocomplete
//= require Leaflet.fullscreen
//= require Leaflet.ExtraMarkers

// Leaflet layer visibility control.
GeoBlacklight.Controls.Layers = function() {
  var baseMap = {
    "Basemap": this.selectBasemap(),
    "None": L.tileLayer('')
  };

  var overlay = {
    "Overlay": this.overlay
  }

  this.map.addControl(new L.control.layers(baseMap, overlay));
};

GeoBlacklight.Controls.Fullscreen = function() {
  this.map.addControl(new L.Control.Fullscreen({
    position: 'topright'
  }));
};

// Controls whether dynamic search on index page map is supressed
GeoBlacklight.supressDynamicSearch = false;
