// additional leaflet base layers

GeoBlacklight.Basemaps.outdoors = L.tileLayer(
  'https://api.tiles.mapbox.com/v4/mapbox.outdoors/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZWxqb3JkYWNoZSIsImEiOiIyNWVkMzk3Zjg4ODM1MDY0MzFmNzYwNjA3NzIzOTgzZSJ9.4EgS3PeSYEhPLy_CaCExSQ', {
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
    maxZoom: 18,
    worldCopyJump: false,
    detectRetina: true,
    continuousWorld: false,
    noWrap: true
  }
);

GeoBlacklight.Basemaps.mapboxLite = L.tileLayer(
  'https://api.tiles.mapbox.com/v4/mapbox.light/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6IlhHVkZmaW8ifQ.hAMX5hSW-QnTeRCMAy9A8Q&update=iepyi', {
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
    maxZoom: 18,
    worldCopyJump: true,
    detectRetina: true
  }
 );

GeoBlacklight.Basemaps.antique = L.tileLayer(
  'https://cartocdn_{s}.global.ssl.fastly.net/base-antique/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
    maxZoom: 18,
    worldCopyJump: true,
    detectRetina: true
  }
);

GeoBlacklight.Basemaps.positron = L.tileLayer(
  'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
    worldCopyJump: true,
    detectRetina: true
  }
);

GeoBlacklight.Basemaps.esri =  L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}', {
  attribution: 'Tiles &copy; Esri &mdash; Source: Esri, DeLorme, NAVTEQ, USGS, Intermap, iPC, NRCAN, Esri Japan, METI, Esri China (Hong Kong), Esri (Thailand), TomTom, 2012',
  minZoom: 1,
  maxZoom: 18,
  worldCopyJump: false,
  detectRetina: true,
  noWrap: true
});

