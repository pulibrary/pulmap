import '@geoblacklight/frontend/dist/style.css'
import { OlInitializer } from '@geoblacklight/frontend'
import TileLayer from 'ol/layer/Tile'
import XYZ from 'ol/source/XYZ'
import { pulmapBasemaps } from '../openlayers/basemaps'

// Override baseLayer function to add ESRI basemap
class PulmapOlInitializer extends OlInitializer {
  baseLayer () {
    const basemap = pulmapBasemaps[this.data.basemap]
    const layer = new TileLayer({
      source: new XYZ({
        attributions: basemap.attribution,
        url: basemap.url,
        maxZoom: basemap.maxZoom
      })
    })
    return layer
  }
}

document.addEventListener('DOMContentLoaded', () => {
  new PulmapOlInitializer().run()
})
