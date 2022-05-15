import path from "path";
import rateLimit from "express-rate-limit";

export const blueprintPath = path.resolve(`${__dirname}`, "../assets/blueprints");

export const emotePath = path.resolve(`${__dirname}`, "../assets/emotes");

export const cachePath = path.resolve(`${__dirname}`, "../assets/emotes/cache");

export const environment = process.env.NODE_ENV;

export const port = 4000;

export const rateLimitOptions:rateLimit.Options = {
  max: 5000, // max requests
  windowMs: 60 * 60 * 1000, // 1 Hour
  message: "Too many requests.",
};

export const payloadLimit = { limit: "10kb" };
