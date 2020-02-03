# HealthTraxx

Tracks fictional healthcare payors' reimbursement amounts for different procedures.

## Requirements
- poll rate is configurable per procedure
- all 3 payors are polled at the same time for a given procedure
  - skip payors that don't reimburse for that procedure
- a record per time interval
  - when the values were scraped
  - amount for the payors

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `health_traxx` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:health_traxx, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/health_traxx](https://hexdocs.pm/health_traxx).
