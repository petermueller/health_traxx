defmodule HealthTraxx.ProcedurePolling.Supervisor do
  use Supervisor

  alias HealthTraxx.Reimbursements

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Reimbursements.list_procedures_with_payors()
    |> Enum.map(& {HealthTraxx.ProcedurePolling.ProcedurePoller, &1})
    |> Supervisor.init(strategy: :one_for_one)
  end
end
