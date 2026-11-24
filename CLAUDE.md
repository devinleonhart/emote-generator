# Emote Generator

Read README.md for commands, addresses and variables. Rails 8.1 on Ruby 4.0, Hotwire, ruby-vips, SQLite.

- The catalog (`app/models/catalog.rb`) reads the parts' directory each time. Names from requests are only compared
  with it, never made into a path.
- `Emote` rounds after each step, as canvas did, so emotes keep their look. Nothing is stored.
- nginx lets every 200 be kept for a week, so the page sends `no-store`.
- There are no sessions, cookies or users. Only MCP has tokens, from the `tailnet_mcp` gem.
- `contract/` holds the recorded answers of the Express version over made-up parts, and scripts to replay them.
- Never open or display an emote or a part. Specs draw their own.
