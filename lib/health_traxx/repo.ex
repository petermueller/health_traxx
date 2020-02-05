defmodule HealthTraxx.Repo do
  use Ecto.Repo,
    otp_app: :health_traxx,
    adapter: Ecto.Adapters.Postgres
end
