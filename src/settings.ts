import path from "path"
import { fileURLToPath } from "url"

// Recreate __dirname for ESM
const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

import type { HelmetOptions } from "helmet"

export const blueprintPath = path.resolve(__dirname, "../assets/blueprints")
export const emotePath = path.resolve(__dirname, "../assets/emotes")
export const cachePath = path.resolve(__dirname, "../assets/emotes/cache")

export const environment = process.env.NODE_ENV
export const port = 4000

export const rateLimitOptions = {
  max: 5000,
  windowMs: 60 * 60 * 1000,
  message: "Too many requests.",
}

export const helmetOptions: HelmetOptions = {
  contentSecurityPolicy: {
    directives: {
      "default-src": ["'self'"],
      "img-src": ["'self'"],
      "script-src": null,
      "style-src": ["'self'"],
      "script-src-attr": null,
    },
  },
  crossOriginResourcePolicy: {
    policy: "cross-origin",
  },
}

export const payloadLimit = { limit: "10kb" }
