// additional leaflet base layers
GeoBlacklight.Basemaps.esri = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}', {
  attribution: 'Tiles &copy; Esri &mdash; Source: Esri, DeLorme, NAVTEQ, USGS, Intermap, iPC, NRCAN, Esri Japan, METI, Esri China (Hong Kong), Esri (Thailand), TomTom, 2012',
  minZoom: 2,
  maxZoom: 18,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
})
