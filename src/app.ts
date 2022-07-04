import express from "express";
import cors from "cors";
import rateLimit from "express-rate-limit";
import helmet from "helmet";
import { cachePath, payloadLimit, port, rateLimitOptions } from "./settings";
import { routes } from "./routes";

const app = express();

if (process.env.NODE_ENV !== "production") {
  app.use(cors());
}
app.use(rateLimit(rateLimitOptions));
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      "default-src": ["self", "devleo.org", "*.devleo.org"]
    }
  }
}));
app.use(express.json(payloadLimit));
app.use(express.static(cachePath));
app.use(express.static("public"));

routes(app);

console.log(`Listening on ${port}!`);
app.listen(port);
