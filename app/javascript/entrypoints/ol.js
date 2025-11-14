import '@geoblacklight/frontend/dist/style.css'
import OlInitializer from '../openlayers/ol_initializer'

document.addEventListener('DOMContentLoaded', () => {
  new OlInitializer().run()
})
