# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_commerce,
  ecto_repos: [PhoenixCommerce.Repo]

# Configures the endpoint
config :phoenix_commerce, PhoenixCommerce.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2FcuqyuDBHIMi3RiePtTePX2LQNkzPnBs8nGQnGWJbsdHrP0Wet9qnyEcKruKdM5",
  render_errors: [view: PhoenixCommerce.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixCommerce.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :arc,
  bucket: "phoenix-commerce-web"

config :ex_aws,
  access_key_id: [System.get_env("AWS_ACCESS_KEY_ID"), :instance_role],
  secret_access_key: [System.get_env("AWS_SECRET_ACCESS_KEY"), :instance_role]

config :stripity_stripe,
  secret_key: System.get_env("STRIPE_SECRET_KEY")
