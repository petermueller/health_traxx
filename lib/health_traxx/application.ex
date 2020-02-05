defmodule HealthTraxx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # TODO - decide what supervision mode and order. Prob just one_for_all to start, but potentially rest_for_one once things are built

    children = [
      {HealthTraxx.Repo, []},
      {HealthTraxx.ProcedurePolling.Loader, []},
      {HealthTraxx.ProcedurePolling.Supervisor, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HealthTraxx.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
