import { Express } from "express";
import { getAllBlueprints, getAllBlueprintsForCharacter, getBlueprint } from "./blueprint";
import { buildEmote, getCachedEmoteList, getCachedEmotePath } from "./emote";
import { listAllParts, listAllPartsForCharacter } from "./part";
import { allPartsPresent } from "./util";

export const routes = (app:Express):void => {
  app.get("/emote", async(req, res) => {
    const key = req.query.key as string;
    const blueprint: Blueprint = {
      character: req.query.character as string,
      head: req.query.head as string,
      eyebrows: req.query.eyebrows as string,
      eyes: req.query.eyes as string,
      mouth: req.query.mouth as string,
    };

    if (key && key !== "") {
      try {
        const cachedEmotePath = await getCachedEmotePath(key);
        if (cachedEmotePath) {
          res.sendFile(cachedEmotePath);
        } else if (getBlueprint(key)) {
          const cachedEmotePath = await buildEmote(key, getBlueprint(key));
          res.sendFile(cachedEmotePath);
        } else {
          res.statusMessage = "No blueprint matches given key.";
          res.sendStatus(404);
        }
      } catch (error) {
        res.statusMessage = error.message;
        res.sendStatus(500);
      }
    } else if (allPartsPresent(blueprint)) {
      try {
        const cachedEmotePath = await buildEmote("tmp", blueprint);
        res.sendFile(cachedEmotePath);
      } catch (error) {
        res.statusMessage = error.message;
        res.sendStatus(500);
      }
    } else {
      res.statusMessage = "Bad or missing params.";
      res.sendStatus(400);
    }
  });

  app.get("/emote/cache", async(_req, res) => {
    try {
      res.send(await getCachedEmoteList());
    } catch (error) {
      res.statusMessage = error.message;
      res.sendStatus(500);
    }
  });

  app.get("/part", async(_req, res) => {
    try {
      res.send(await listAllParts());
    } catch (error) {
      res.statusMessage = error.message;
      res.sendStatus(500);
    }
  });

  app.get("/part/:character", async(req, res) => {
    const character = req.params.character.toLowerCase();
    try {
      res.send(await listAllPartsForCharacter(character));
    } catch (error) {
      res.statusMessage = error.message;
      res.sendStatus(500);
    }
  });

  app.get("/blueprint", async(_req, res) => {
    try {
      res.send(await getAllBlueprints());
    } catch (error) {
      res.statusMessage = error.message;
      res.sendStatus(500);
    }
  });

  app.get("/blueprint/:character", async(req, res) => {
    const character = req.params.character.toLowerCase();
    try {
      res.send(await getAllBlueprintsForCharacter(character));
    } catch (error) {
      res.statusMessage = error.message;
      res.sendStatus(500);
    }
  });
};
