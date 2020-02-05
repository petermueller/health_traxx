require Logger

defmodule HealthTraxx.ProcedurePolling.PollTracker do
  # use GenServer
  use GenStateMachine, callback_mode: :state_functions

  alias HealthTraxx.ProcedurePolling.PayorProcedureRefresher

  defstruct responses: [], payors_responded: [], previous_amounts: [], procedure: nil

  def child_spec(%{name: procedure_name} = procedure) do
    %{
      id: {__MODULE__, procedure_name},
      start: {__MODULE__, :start_link, [procedure]}
    }
  end

  # GenServer behaviour impls

  def start_link(%{name: procedure_name} = procedure) do
    GenStateMachine.start_link(__MODULE__, procedure,
      name: {:global, {__MODULE__, procedure_name}}
    )
  end

  def init(procedure) do
    data = struct!(__MODULE__, procedure: procedure)
    {:ok, :not_polled_yet, data, [{:next_event, :internal, :start_polling}]}
  end

  def not_polled_yet(:internal, :start_polling, data) do
    refresh_from_payors(data.procedure)

    # TODO - add timeout action
    {:next_state, :awaiting_responses, data}
  end

  # TODO - add response timeout handlers
  def awaiting_responses(_event_type, {:response_received, response}, data) do
    Logger.debug("#{data.procedure.name} response: #{response}")
    # if response is still needed
    #   add to list of responses
    # else
    #   alert that something came in twice, or for the wrong process

    # if no further responses needed
    #   transition to persisting
    # else
    #  keep_state and updated data
    :keep_state_and_data
  end

  # def not_polled_yet(event_type, event_content, data) do
  #   :keep_state_and_data
  # end

  # Public Callbacks

  # Private functions

  defp refresh_from_payors(%{name: procedure_name, payors: payors}) do
    Logger.debug("Sending to #{length(payors)} payors for #{procedure_name}")

    Enum.each(payors, fn payor ->
      spawn(fn ->
        response = PayorProcedureRefresher.refresh(procedure_name, payor)

        GenStateMachine.cast(
          {:global, {__MODULE__, procedure_name}},
          {:response_received, response}
        )
      end)
    end)
  end
end
