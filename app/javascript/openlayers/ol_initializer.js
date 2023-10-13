import '../stylesheets/openlayers.css';
import { Map, View } from 'ol';
import TileLayer from 'ol/layer/Tile';
import VectorTile from 'ol/layer/VectorTile';
import OSM from 'ol/source/OSM';
import GeoJSON from 'ol/format/GeoJSON.js';
import { useGeographic, transform } from 'ol/proj';
import {
  Style, Stroke, Fill, Circle,
} from 'ol/style';
import GeoTIFF from 'ol/source/GeoTIFF.js';
import WebGLTileLayer from 'ol/layer/WebGLTile.js';
import { FullScreen, defaults as defaultControls } from 'ol/control.js';
import { PMTilesVectorSource } from '@/openlayers/pmtiles-layer';

export default class OlInitializer {
  constructor() {
    this.element = document.getElementById('ol-map');
    if (!this.element) return false;
    this.data = this.element.dataset;
    if (!this.data) return false;
    this.extent = new GeoJSON().readFeatures(this.data.mapGeom)[0].getGeometry().getExtent();
    this.baseLayer = new TileLayer({ source: new OSM() });
    if (this.data.protocol == 'Pmtiles') {
      this.initialize_pmtiles();
    } else if (this.data.protocol == 'Cog') {
      this.initialize_cog();
    }
  }

  initialize_pmtiles() {
    const vectorLayer = new VectorTile({
      declutter: true,
      source: new PMTilesVectorSource({
        url: this.data.url,
      }),
      style: new Style({
        stroke: new Stroke({
          color: '#7070B3',
          width: 1,
        }),
        fill: new Fill({
          color: '#FFFFFF',
        }),
        image: new Circle({
          radius: 7,
          fill: new Fill({
            color: '#7070B3',
          }),
          stroke: new Stroke({
            color: '#FFFFFF',
            width: 2,
          }),
        }),
      }),
    });

    useGeographic();
    const map = new Map({
      controls: defaultControls().extend([new FullScreen()]),
      layers: [this.baseLayer, vectorLayer],
      target: 'ol-map',
    });
    map.getView().fit(this.extent, map.getSize());
  }

  initialize_cog() {
    const source = new GeoTIFF({
      sources: [{ url: this.data.url }],
    });

    source.getView().then((view) => {
      const map = new Map({
        controls: defaultControls().extend([new FullScreen()]),
        target: 'ol-map',
        layers: [
          this.baseLayer,
          new WebGLTileLayer({
            source,
          }),
        ],
        view: new View({
          center: view.center,
        }),
      });
      map.getView().fit(view.extent, map.getSize());
    });
  }
}
