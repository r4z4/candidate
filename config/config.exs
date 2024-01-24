# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :fan_can,
  ecto_repos: [FanCan.Repo]

# Configures the endpoint
config :fan_can, FanCanWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: FanCanWeb.ErrorHTML, json: FanCanWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: FanCan.PubSub,
  live_view: [signing_salt: "NjuPBj3u"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :fan_can, FanCan.Mailer, adapter: Swoosh.Adapters.Local

config :ex_heroicons, type: "outline"

config :fan_can, FanCan.Repo, types: FanCan.PostgrexTypes

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :hammer,
  backend: {Hammer.Backend.ETS,
            [expiry_ms: 60_000 * 60 * 4,
             cleanup_interval_ms: 60_000 * 10]}

# Configures Elixir's Logger
# config :logger, :console,
#   format: "$time $metadata[$level] $message\n",
#   metadata: [:request_id]

config :logger,
  backends: [:console,
             {LoggerFileBackend, :info},
             {LoggerFileBackend, :error}]

  # Setting format seems to have no effect here.
  # format: {FanCan.LoggerFormatter, :format},
  # format: "$time $metadata[$level] $message\n",
  # metadata: [:request_id]

config :logger, :info,
  path: "/tmp/info/info.log",
  format: {FanCan.LoggerFormatter, :format},
  level: :info,
  metadata: [:mfa]

config :logger, :error_log,
  path: "/tmp/error/error.log",
  format: {FanCan.LoggerFormatter, :format},
  level: :debug,
  metadata: [:mfa]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
