// Load the GeoBlacklight leaflet.
const L = window.L
// These are the modules that leaflet-geosearch requires from leaflet.
// If we upgrade to another major version, we may need to change these.
// To find the required modules you can run:
// `head -1 node_modules/leaflet-geosearch/dist/geosearch.module.js`
export const { Control, DomEvent, DomUtil, FeatureGroup, Marker, Util } = L
export default L
