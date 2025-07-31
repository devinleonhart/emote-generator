import { defineConfig } from "vite"
import { fileURLToPath } from "node:url"
import vue from "@vitejs/plugin-vue"

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue({
      template: { transformAssetUrls: true }
    })
  ],
  server: {
    host: "0.0.0.0",
    port: 5173,
    watch: {
      usePolling: true
    }
  }
})
