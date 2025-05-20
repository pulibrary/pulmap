// TODO: Move to application.js entrypoint
import BlacklightRangeLimit from 'blacklight-range-limit'

import { GeoSearchControl, EsriProvider } from 'leaflet-geosearch'
BlacklightRangeLimit.init({ onLoadHandler: window.Blacklight.onLoad })
window.geoCoder = new GeoSearchControl({
  provider: new EsriProvider(),
  style: 'button',
  showMarker: false,
  autoClose: true,
  searchLabel: 'Search for location',
  keepResult: true
})
