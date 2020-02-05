import Config

config :health_traxx, HealthTraxx.Repo,
  database: "health_traxx_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
