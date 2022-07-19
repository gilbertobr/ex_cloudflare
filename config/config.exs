import Config

config :cloudflare,
  auth_token: System.get_env("API_KEY_CLOUDFLARE")

config :logger, level: :info
