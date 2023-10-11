import '../stylesheets/openlayers.css';
import {Map, View} from 'ol';
import TileLayer from 'ol/layer/Tile';
import VectorTile from 'ol/layer/VectorTile';
import OSM from 'ol/source/OSM'
import GeoJSON from 'ol/format/geojson'
import { useGeographic, transform } from 'ol/proj';
import {Style, Stroke, Fill} from 'ol/style';
import GeoTIFF from 'ol/source/GeoTIFF.js';
import WebGLTileLayer from 'ol/layer/WebGLTile.js';
import { PMTilesVectorSource } from '@/components/pmtiles-layer'
import {FullScreen, defaults as defaultControls} from 'ol/control.js'

document.addEventListener('DOMContentLoaded', () => {
  const element = document.getElementById('ol-map')
  if (!element) return false
  const data = element.dataset
  const baseLayer = new TileLayer({ source: new OSM() });
  const geom = data.mapGeom
  const extent = new GeoJSON().readFeatures(geom)[0].getGeometry().getExtent()
  if (data && data.protocol == 'Pmtiles') {
    const vectorLayer = new VectorTile({
        declutter: true,
        source: new PMTilesVectorSource({
          // url: "https://pul-tile-images.s3.amazonaws.com/Dept_of_Public_Works_Roadwork_Projects.pmtiles",
          // url: "https://pul-tile-images.s3.amazonaws.com/pmtiles/parcels.pmtiles",
          url: data.url
        }),
        style: new Style({
          stroke: new Stroke({
            color: '#7070B3',
            width: 1,
          }),
          fill: new Fill({
            color: '#FFFFFF',
          })
        })
      });

      useGeographic();
      const map = new Map({
        controls: defaultControls().extend([new FullScreen()]),
        layers: [baseLayer, vectorLayer],
        target: 'ol-map'
      });
      map.getView().fit(extent, map.getSize());
  } else if (data.protocol == 'Cog') {
      const source = new GeoTIFF({
        sources: [ { url: data.url } ]
      });

      source.getView().then((view) => {
        const map = new Map({
          controls: defaultControls().extend([new FullScreen()]),
          target: 'ol-map',
          layers: [
            baseLayer,
            new WebGLTileLayer({
              source: source,
            }),
          ],
          view: new View({
            center: view.center
          })
        })
        map.getView().fit(view.extent, map.getSize())
      })
  }
})
