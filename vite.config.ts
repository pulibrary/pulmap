import { fileURLToPath } from 'node:url'
import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
  plugins: [
    RubyPlugin(),
  ],
  resolve: {
    alias: [
      // Load Leaflet from GeoBlacklight using a shim.
      // Enables the newest version of leaflet-geosearch work with our current javascript.
      {
        find: /^leaflet$/,
        replacement: fileURLToPath(new URL('./app/javascript/shims/leaflet_global.cjs', import.meta.url)),
      },
    ],
  },
})
