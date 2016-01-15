// additional leaflet base layers

GeoBlacklight.Basemaps.outdoors = L.tileLayer(
  'https://api.tiles.mapbox.com/v4/mapbox.outdoors/{z}/{x}/{y}.png?access_token=tk.eyJ1IjoiZWxqb3JkYWNoZSIsImV4cCI6MTQ1Mjg5ODg3MCwiaWF0IjoxNDUyODk1MjcwLCJzY29wZXMiOlsiZXNzZW50aWFscyIsInNjb3BlczpsaXN0IiwibWFwOnJlYWQiLCJtYXA6d3JpdGUiLCJ1c2VyOnJlYWQiLCJ1c2VyOndyaXRlIiwidXBsb2FkczpyZWFkIiwidXBsb2FkczpsaXN0IiwidXBsb2Fkczp3cml0ZSIsInN0eWxlczp0aWxlcyIsInN0eWxlczpyZWFkIiwiZm9udHM6cmVhZCIsInN0eWxlczp3cml0ZSIsInN0eWxlczpsaXN0Iiwic3R5bGVzOmRyYWZ0IiwiZm9udHM6bGlzdCIsImZvbnRzOndyaXRlIiwiZm9udHM6bWV0YWRhdGEiLCJkYXRhc2V0czpyZWFkIiwiZGF0YXNldHM6d3JpdGUiXSwiY2xpZW50IjoibWFwYm94LmNvbSJ9.r7GhabKizIsihUcy_DJdbA&update=ijg8b', {
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
    maxZoom: 18,
    worldCopyJump: false,
    continuousWorld: false,
    noWrap: true
  }
);

GeoBlacklight.Basemaps.mapboxLite = L.tileLayer(
  'https://api.tiles.mapbox.com/v4/mapbox.light/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6IlhHVkZmaW8ifQ.hAMX5hSW-QnTeRCMAy9A8Q&update=iepyi', {
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
    maxZoom: 18,
    worldCopyJump: true
  }
 );

GeoBlacklight.Basemaps.antique = L.tileLayer(
  'https://cartocdn_{s}.global.ssl.fastly.net/base-antique/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
    maxZoom: 18,
    worldCopyJump: true
  }
);

GeoBlacklight.Basemaps.positron = L.tileLayer(
  'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
    maxZoom: 18,
    worldCopyJump: false,
    continuousWorld: false,
    noWrap: true
  }
);
