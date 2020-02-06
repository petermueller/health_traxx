defmodule HealthTraxx.ProcedurePolling.Supervisor do
  use Supervisor

  alias HealthTraxx.Reimbursements

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Reimbursements.list_current_reimbursable_procedure_amounts()
    |> Enum.map(& {HealthTraxx.ProcedurePolling.PollTracker, &1})
    |> Supervisor.init(strategy: :one_for_one)
  end
end
