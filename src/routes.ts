import { buildEmote, getCachedEmoteList, getCachedEmotePath } from "./emote.js"
import { listAllParts, listAllPartsForCharacter, listAllCharacters } from "./part.js"
import { allPartsPresent } from "./util.js"
import path from "path"
import { fileURLToPath } from "url"

import type { Express } from "express"
import type { EmoteConfig } from "./types/main"

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

export const routes = (app:Express):void => {
  // Serve Vue frontend at root path
  app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "../public/index.html"))
  })

  app.get("/emote", async(req, res) => {
    const emoteConfig: EmoteConfig = {
      character: req.query.character as string,
      head: req.query.head as string,
      eyebrows: req.query.eyebrows as string,
      eyes: req.query.eyes as string,
      mouth: req.query.mouth as string,
    }

    if (allPartsPresent(emoteConfig)) {
      try {
        const cachedEmotePath = await buildEmote("tmp", emoteConfig)
        res.sendFile(cachedEmotePath)
      } catch (error) {
        if (error instanceof Error) {
          res.statusMessage = error.message
        } else {
          res.statusMessage = "Unknown server error"
        }
        res.sendStatus(500)
      }
    } else {
      res.statusMessage = "Bad or missing params."
      res.sendStatus(400)
    }
  })

  app.get("/emote/cache", async(_req, res) => {
    try {
      res.send(await getCachedEmoteList())
    } catch (error) {
      if (error instanceof Error) {
        res.statusMessage = error.message
      } else {
        res.statusMessage = "Unknown server error"
      }
      res.sendStatus(500)
    }
  })

  app.get("/part", async(_req, res) => {
    try {
      res.send(await listAllParts())
    } catch (error) {
      if (error instanceof Error) {
        res.statusMessage = error.message
      } else {
        res.statusMessage = "Unknown server error"
      }
      res.sendStatus(500)
    }
  })

  app.get("/part/:character", async(req, res) => {
    const character = req.params.character.toLowerCase()
    try {
      res.send(await listAllPartsForCharacter(character))
    } catch (error) {
      if (error instanceof Error) {
        res.statusMessage = error.message
      } else {
        res.statusMessage = "Unknown server error"
      }
      res.sendStatus(500)
    }
  })

  app.get("/character", async(_req, res) => {
    try {
      res.send(await listAllCharacters())
    } catch (error) {
      if (error instanceof Error) {
        res.statusMessage = error.message
      } else {
        res.statusMessage = "Unknown server error"
      }
      res.sendStatus(500)
    }
  })
}
