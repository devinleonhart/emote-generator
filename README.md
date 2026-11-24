# Emote Generator

Composes emotes, pictures of a character, from a head, eyebrows, eyes and a mouth.

## Features

| Address | Gives |
|---|---|
| `/` | The page: choose a character and its parts, and see the emote |
| `/emote?character=&head=&eyebrows=&eyes=&mouth=` | An emote, as PNG |
| `/character` | The characters |
| `/part`, `/part/:character` | The parts' file names |
| `/emote/cache`, `/:name.png` | Emotes that were once stored |
| `/mcp` | MCP, for hosts and tokens that are allowed |

Parts are PNG files named `<character>_<part>_<name>.png` in `$ASSETS_DIR/emotes`.

## Development

Needs Docker; all Ruby runs in containers. Without parts of its own, development draws made-up ones.

```bash
docker compose up web                                    # http://localhost:4000
docker compose run --rm -e RAILS_ENV=test web bin/ci     # everything CI checks; ends in OK
```

## Environment

| Variable | Purpose |
|---|---|
| `SECRET_KEY_BASE` | Production secret |
| `ASSETS_DIR` | Holds `emotes/`, and `emotes/cache/` (default `/app/assets`) |
| `DATABASE_PATH` | SQLite file of the MCP tokens |
| `APP_HOST` | The host production answers to (default `emote.devleo.me`) |
| `MCP_HOST` | The only host that `/mcp` answers; unset, `/mcp` does not exist |

## MCP

`POST /mcp` lists the characters and their parts, and gives the address of an emote. Emotes are given by address, never as data.

Each machine has its own token, which carries `read` and expires:

```bash
bin/rails mcp:tokens:issue MACHINE=<name> DAYS=90   # prints the token once
bin/rails mcp:tokens:list
bin/rails mcp:tokens:revoke ID=<id>
```

The endpoint, limits and tokens come from the [`tailnet_mcp`](https://github.com/devinleonhart/tailnet-mcp) gem. The tools are in `app/mcp`.

## Deployment

A merge to `master` runs CI, which publishes `devleo/emote-generator:latest` to Docker Hub when the checks pass. On the server:

```bash
docker compose pull emote-generator
docker compose run --rm --no-deps emote-generator bin/rails db:migrate   # only with a new migration
docker compose up -d emote-generator
```

Migrations never run at boot.

## Architecture

- `Catalog` reads the characters and parts from the file names.
- `Emote` composes the parts with libvips, rounding as a browser's canvas does.
- The only database is the SQLite file of the MCP tokens.
