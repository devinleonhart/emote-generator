Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  match "mcp", to: "tailnet_mcp/endpoint#handle", via: :all, format: false

  root to: "generators#show"

  scope format: false do
    get "character", to: "parts#characters"
    get "part", to: "parts#index"
    get "part/:character", to: "parts#show", constraints: { character: %r{[^/]+} }
    get "emote", to: "emotes#show", as: :emote
    get "emote/cache", to: "cached_emotes#index"
    get ":name", to: "cached_emotes#show", constraints: { name: %r{[^/]+\.png} }
    match "*path", to: "missing#show", via: :all
  end
end
