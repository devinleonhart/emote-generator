# emote-generator

Build emotes with ease.

## Development with Docker

```bash
cd /source/emote-generator
docker docker build -t emote .
docker run -p 4000:4000 emote

Then visit:
http://localhost:4000/
```

## Development with Docker (Live Reload)

```bash
cd /source/emote-generator
docker compose -f docker-compose.dev.yml up

# Then visit:
http://localhost:4000/
