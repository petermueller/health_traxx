defmodule HealthTraxx.ProcedurePolling.ProcedurePoller do
  use GenServer

  def child_spec({procedure_name, _payor_values} = arg) do
    %{
      id: {__MODULE__, procedure_name},
      start: {__MODULE__, :start_link, [arg]}
    }
  end

  def start_link({procedure_name, _payor_values} = arg) do
    IO.inspect(procedure_name, label: "Started ProcPoller")
    GenServer.start_link(__MODULE__, [arg])
  end

  def init(arg) do
    {:ok, arg}
  end
end
