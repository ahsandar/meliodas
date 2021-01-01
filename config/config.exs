# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :meliodas, MeliodasWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "setYourSecretKeyBase",
  render_errors: [view: MeliodasWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Meliodas.PubSub,
  live_view: [signing_salt: "JeLpbVeM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


config :logger,
backends: [:console, Sentry.LoggerBackend]

config :sentry,
  dsn: "https://public_key@app.getsentry.com/1",
  environment_name: Mix.env(),
  included_environments: [:prod],
  enable_source_code_context: true,
  root_source_code_paths: [File.cwd!()],
  tags: %{
    env: "production"
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
