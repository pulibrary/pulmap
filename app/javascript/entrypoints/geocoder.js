import { GeoSearchControl, EsriProvider } from 'leaflet-geosearch'
window.geoCoder = new GeoSearchControl({
  provider: new EsriProvider(),
  style: 'button',
  showMarker: false,
  autoClose: true,
  searchLabel: 'Search for location',
  keepResult: true
})
