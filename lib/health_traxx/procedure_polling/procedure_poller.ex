defmodule HealthTraxx.ProcedurePolling.ProcedurePoller do
  use GenServer

  def child_spec(%{name: procedure_name} = procedure) do
    %{
      id: {__MODULE__, procedure_name},
      start: {__MODULE__, :start_link, [procedure]}
    }
  end

  def start_link(%{name: procedure_name} = procedure) do
    IO.inspect(procedure_name, label: "Started ProcPoller")
    GenServer.start_link(__MODULE__, [procedure])
  end

  def init(arg) do
    {:ok, arg}
  end
end
