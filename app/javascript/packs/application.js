/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
import 'babel-polyfill';
import 'whatwg-fetch';
/* eslint import/no-extraneous-dependencies: [0] import/no-unresolved: [0] import/extensions: [0] */
import GeoCoder from 'geo-coder';

// Bind the GeoCoder Object to the window instance
/* global $ document window */
$(document).ready(() => {
  window.geoCoder = new GeoCoder(window.LEAFLET_GEOCODER_PROVIDER, {
    params: {
      key: window.LEAFLET_GEOCODER_KEY,
    },
  });
});
