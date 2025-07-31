import fs from "fs"
import path from "path"
import { emotePath } from "./settings.js"
const fsPromises = fs.promises

export const listAllParts = async():Promise<string[]> => {
  const filenames = await fsPromises.readdir(`${emotePath}`)
  const validParts:string[] = []

  filenames.forEach(async(filename: string) => {
    try {
      if (path.extname(filename) === ".png") {
        validParts.push(filename)
      }
    }
    catch (error) {
      console.error(`Failed to read: ${emotePath}/${filename}`)
      throw(new Error(`Failed to read: ${emotePath}/${filename}`))
    }
  })

  return validParts
}

export const listAllPartsForCharacter = async(character:string):Promise<string[]> => {
  try {
    const dirContents = await fsPromises.readdir(`${emotePath}`)
    return dirContents.filter((partFilename) => {
      return partFilename.startsWith(`${character.toLowerCase()}_`)
    })
  } catch (error) {
    throw (new Error("listAllPartsForCharacter failed!"))
  }
}

export const listAllCharacters = async():Promise<string[]> => {
  try {
    const dirContents = await fsPromises.readdir(`${emotePath}`)
    const characters = new Set<string>()

    dirContents.forEach((partFilename) => {
      if (path.extname(partFilename) === ".png") {
        const character = partFilename.split("_")[0]
        characters.add(character)
      }
    })

    return Array.from(characters).sort()
  } catch (error) {
    throw (new Error("listAllCharacters failed!"))
  }
}
