Blacklight.onLoad(function () {
  'use strict';

  $('[data-map="index"]').each(function () {
    GeoBlacklight.MapToggle.load();
  });
});

GeoBlacklight.MapToggle = {
  load: function () {
    var _this = this;
    if (_this.getState() === 'on') {
      $('#map-toggle').bootstrapToggle('on');
      _this.on();
    } else {
      $('#map-toggle').bootstrapToggle('off');
      _this.off();
    }
    _this.setupEvents();
  },

  setupEvents: function () {
    var _this = this;
    $('#map-toggle').change(function () {
      _this.setState($('#map-toggle').prop('checked'));
      if (_this.getState() === 'on') {
        _this.on();
      } else {
        _this.off();
      }
    });
  },

  getState: function () {
    var state = localStorage.getItem('toggleState');
    if (state) {
      return state;
    } else {
      return 'off';
    }
  },

  setState: function (checked) {
    if (checked) {
      localStorage.setItem('toggleState', 'on');
    } else {
      localStorage.setItem('toggleState', 'off');
    }
  },

  on: function () {
    $('#map-container').show();
    $('.facet-view').hide();
    $('#side-content').addClass('map-view');
    $('#content').addClass('map-view');
  },

  off: function () {
    $('#map-container').hide();
    $('.facet-view').show();
    $('#side-content').removeClass('map-view');
    $('#content').removeClass('map-view');
  }
};
