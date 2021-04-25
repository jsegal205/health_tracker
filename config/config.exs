# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :health_tracker,
  ecto_repos: [HealthTracker.Repo]

# Configures the endpoint
config :health_tracker, HealthTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4+vuqMKkRNwdYc6uEs62GsDDlOFzuw6quB+AxuZETB0JCwntmPfnWFOhOexhyO+N",
  render_errors: [view: HealthTrackerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HealthTracker.PubSub,
  live_view: [signing_salt: "bWifvxFl"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
