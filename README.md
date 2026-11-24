# Emote Generator

Composes emotes, pictures of a character, from a head, eyebrows, eyes and a mouth.

## Development

Everything runs in containers. Without parts of its own, development draws made-up ones.

```bash
docker compose up web                                    # http://localhost:4000
docker compose run --rm -e RAILS_ENV=test web bin/ci     # everything CI checks; ends in OK
```

## Addresses

| Address | Gives |
|---|---|
| `/` | The page |
| `/emote?character=&head=&eyebrows=&eyes=&mouth=` | An emote, as PNG |
| `/character` | The characters |
| `/part`, `/part/:character` | The parts' file names |
| `/emote/cache`, `/:name.png` | Emotes that were once stored |
| `/mcp` | MCP, for hosts and tokens that are allowed |

Parts are PNG files named `<character>_<part>_<name>.png` in `$ASSETS_DIR/emotes`.

## Environment

| Variable | Purpose |
|---|---|
| `SECRET_KEY_BASE` | Production secret |
| `ASSETS_DIR` | Holds `emotes/`, and `emotes/cache/` (default `/app/assets`) |
| `DATABASE_PATH` | SQLite file of the MCP tokens |
| `APP_HOST` | The host production answers to (default `emote.devleo.me`) |
| `MCP_HOST` | The only host that `/mcp` answers; unset, `/mcp` does not exist |

Migrations never run at boot: `bin/rails db:migrate`. Tokens: `bin/rails mcp:tokens:issue MACHINE=<name>`,
`:list`, `:revoke`.
