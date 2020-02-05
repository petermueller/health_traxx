import Config

config :health_traxx,
  ecto_repos: [HealthTraxx.Repo]

import_config "#{Mix.env()}.exs"
