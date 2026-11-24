require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module EmoteGenerator
  class Application < Rails::Application
    config.load_defaults 8.1
    config.autoload_lib(ignore: %w[assets tasks])

    # No one signs in, so nothing is remembered.
    config.session_store :disabled
    config.middleware.delete ActionDispatch::Cookies
    config.middleware.delete ActionDispatch::Flash

    # Other sites show emotes.
    config.action_dispatch.default_headers["Cross-Origin-Resource-Policy"] = "cross-origin"

    # Holds emotes/, with the parts, and emotes/cache/, with old emotes.
    config.x.assets = Pathname(ENV.fetch("ASSETS_DIR", Rails.root.join("assets").to_s))
    config.x.site = { host: ENV.fetch("APP_HOST", "emote.devleo.me"), protocol: "https" }
  end
end
