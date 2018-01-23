import * as G from 'leaflet-geosearch';

/**
 * Factory Class for the Provider instance
 */
class ProviderFactory {
  /**
   * Constructor
   * @param {String} providerName the name of the geocoder service provider
   */
  constructor(providerName) {
    this.setClass(providerName);
  }

  /**
   * Factory method for instantiating a new Provider
   * @param {...object} args the args used for the Provider constructor
   * @return {G.Provider} the Provider instance
   */
  new(args) {
    /* eslint new-cap: ["error", { "newIsCap": false }] */
    return new this.klass(args);
  }

  /**
   * Sets the Class for the Provider
   * @param {String} providerName the name of the provider
   * @return {Class} the Provider Class
   */
  setClass(providerName) {
    const map = {
      OpenStreetMap: G.OpenStreetMapProvider,
      Esri: G.EsriProvider,
      Bing: G.BingProvider,
      Google: G.GoogleProvider,
      LocationIQ: G.LocationIQProvider,
    };
    this.klass = map[providerName];
    return this.klass;
  }
}

/**
 * Class for adding the geocoder widget to a Leaflet Map instance
 */
export default class GeoCoder {
  /**
   * Constructor
   * @param {String} providerName the service provider for the geocoding API
   */
  constructor(providerName, providerArgs) {
    const factory = new ProviderFactory(providerName);
    const provider = factory.new(providerArgs);
    this.setProvider(provider);
  }

  /**
   * Set the provider for the Leaflet GeoSearchControl
   * @param {String} prov the service provider for the geocoding API
   * @return {G.GeoSearchControl} the GeoSearchControl instance
   */
  setProvider(prov) {
    const searchControl = new G.GeoSearchControl({
      provider: prov,
      style: 'button',
      showMarker: false,
      autoClose: true,
      searchLabel: 'Search for location',
      keepResult: true,
    });
    this.searchControl = searchControl;
    return searchControl;
  }

  /**
   * Add the geocoder to a Leaflet Map
   * @param {L.Map} map the Map instance
   * @return {L.Map} the modified Map
   */
  addTo(map) {
    map.addControl(this.searchControl);
    return map;
  }
}
