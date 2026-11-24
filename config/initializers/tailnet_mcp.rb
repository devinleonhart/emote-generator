TailnetMcp.configure do |config|
  config.name = "emote"
  config.token_prefix = "emo"
  config.host = ENV["MCP_HOST"].presence
  config.tool_sets = -> { [EmoteTools] }
end
