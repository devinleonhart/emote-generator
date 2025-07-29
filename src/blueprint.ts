import fs from "fs"
import path from "path"
import { blueprintPath } from "./settings.js"
const fsPromises = fs.promises

import type { Blueprint, BlueprintCollection } from "../types/main.d.ts"

let blueprints:BlueprintCollection = {}

export const getBlueprint = (key: string):Blueprint => {
  try {
    return blueprints[key]
  } catch (error) {
    throw (new Error("getBlueprint failed!"))
  }
}

export const getAllBlueprints = async(): Promise<string[]> => {
  try {
    return Object.keys(blueprints).sort()
  } catch (err) {
    throw (new Error("getAllBlueprints failed!"))
  }
}

export const getAllBlueprintsForCharacter = async(character: string): Promise<string[]> => {
  try {
    return Object.keys(blueprints).filter((key) => {
      return key.startsWith(`${character}_`)
    })
  } catch (err) {
    throw (new Error("getAllBlueprintsForCharacter failed!"))
  }
}

async function readBlueprintsDirectory():Promise<void> {
  const filenames = await fsPromises.readdir(`${blueprintPath}`)
  let fileData = {}
  filenames.forEach(async(filename: string) => {
    try {
      if (path.extname(filename) === ".json") {
        fileData = JSON.parse(await fsPromises.readFile(`${blueprintPath}/${filename}`,"utf-8"))
        blueprints = Object.assign(blueprints, fileData)
      }
    }
    catch (error) {
      console.error(`Failed to read: ${blueprintPath}/${filename}`)
      throw(new Error(`Failed to read: ${blueprintPath}/${filename}`))
    }
  })
}

readBlueprintsDirectory()
