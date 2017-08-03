!function(global) {
  'use strict';

    L.Control.FindLoc = L.Control.extend({
        onAdd: function(map) {
            var findLoc = L.DomUtil.create('div');

            findLoc.innerHTML = '<div class="find-loc" id="find-loc"></div>';
            return findLoc;

        },

        onRemove: function(map) {
            // Nothing to do here
        }
    });

    L.control.findloc = function(opts) {
        return new L.Control.FindLoc(opts);
    }

}(this);
