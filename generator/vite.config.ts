import { defineConfig } from "vite"
import { fileURLToPath } from "node:url"
import vue from "@vitejs/plugin-vue"
import path from "path"

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue({
      template: { transformAssetUrls: true }
    })
  ],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
      "@types": path.resolve(__dirname, "./types"),
      "@/components": path.resolve(__dirname, "./src/components"),
      "@/stores": path.resolve(__dirname, "./src/stores"),
      "@/composables": path.resolve(__dirname, "./src/composables"),
      "@/util": path.resolve(__dirname, "./src/util"),
      "@/settings": path.resolve(__dirname, "./src/settings")
    }
  },
  server: {
    proxy: {
      "/api": {
        target: "http://api:4000",
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, "")
      }
    }
  }
})
