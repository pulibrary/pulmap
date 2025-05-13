// TODO: Move to application.js entrypoint
import BlacklightRangeLimit from "blacklight-range-limit";
BlacklightRangeLimit.init({ onLoadHandler: Blacklight.onLoad });

import { GeoSearchControl, EsriProvider } from 'leaflet-geosearch'
window.geoCoder = new GeoSearchControl({
  provider: new EsriProvider(),
  style: 'button',
  showMarker: false,
  autoClose: true,
  searchLabel: 'Search for location',
  keepResult: true
})
