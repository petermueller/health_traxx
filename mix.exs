defmodule HealthTraxx.MixProject do
  use Mix.Project

  def project do
    [
      app: :health_traxx,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {HealthTraxx.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.3"},
      {:postgrex, "~> 0.15.3"},
      {:jason, "~> 1.1"}
    ]
  end
end
