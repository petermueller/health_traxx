require Logger

defmodule HealthTraxx.ProcedurePolling.PollRequestData do
  defstruct payor: nil, old_amount: nil
end

defmodule HealthTraxx.ProcedurePolling.PollTracker do
  use GenStateMachine, callback_mode: :state_functions

  alias HealthTraxx.Reimbursements
  alias HealthTraxx.ProcedurePolling.{PayorProcedureRefresher, PollRequestData}

  @default_timeout :timer.seconds(30)

  defstruct finished_poll_requests: %{},
            procedure_name: nil,
            poll_requests: [],
            procedure_schedule: @default_timeout,
            payor_procedures: []

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
    poll_requests = Enum.map(procedure.payor_procedures, &build_poll_request_data/1)

    data =
      struct!(__MODULE__,
        procedure_name: procedure.name,
        poll_requests: poll_requests,
        payor_procedures: procedure.payor_procedures
      )

    {:ok, :not_polled_yet, data, [{:next_event, :internal, :start_polling_cycle}]}
  end

  def not_polled_yet(:internal, :start_polling_cycle, data) do
    request_refresh_from_payors(data)

    # TODO - add timeout action
    {:next_state, :awaiting_responses, data}
  end

  # TODO - add response timeout handlers
  # TODO - omg this is so gross looking. Make some proper structs out of this stupid Ecto data and pull this crap apart
  def awaiting_responses(_, {:response_received, response}, data) do
    {poll_request_data, new_amount} = response

    Logger.debug(
      "awaiting_responses: [:response_received] #{data.procedure_name} - #{new_amount}"
    )

    data =
      if already_has_response?(data, poll_request_data) do
        Logger.warn("Got a double response: #{response}")
        data
      else
        add_response_to_data(data, response)
      end

    if all_poll_requests_finished?(data) do
      {:keep_state, data, [{:next_event, :internal, :all_requests_completed}]}
    else
      {:keep_state, data}
    end
  end

  def awaiting_responses(:internal, :all_requests_completed, data) do
    persist_responses(data)
    {:next_state, :persisting, data}
  end

  def persisting(_, {:all_persisted, new_amounts}, data) do
    Logger.debug("persisting: [:all_persisted] #{data.procedure_name}")

    Enum.map(new_amounts, fn new_amount ->
      payor_procedure =
        Enum.find(data.payor_procedures, &(&1.id == new_amount.payor_procedure_id))

      struct!(PollRequestData, payor: payor_procedure.payor, old_amount: new_amount)
    end)

    poll_requests = Enum.map(data.payor_procedures, &build_poll_request_data/1)

    data = struct!(data, finished_poll_requests: %{}, poll_requests: poll_requests)

    {:keep_state, data, [{:state_timeout, data.procedure_schedule, :start_polling_cycle}]}
  end

  def persisting(:state_timeout, :start_polling_cycle, data) do
    Logger.debug("persisting: [:start_polling_cycle] #{data.procedure_name}")

    request_refresh_from_payors(data)
    {:next_state, :awaiting_responses, data}
  end

  # Public Callbacks

  def response_received(procedure_name, response) do
    GenStateMachine.cast({:global, {__MODULE__, procedure_name}}, {:response_received, response})
  end

  # Private functions
  defp add_response_to_data(data, {poll_request_data, new_amount}) do
    finished_poll_requests = Map.put(data.finished_poll_requests, poll_request_data, new_amount)
    %{data | finished_poll_requests: finished_poll_requests}
  end

  defp already_has_response?(%{finished_poll_requests: finished_poll_requests}, poll_request) do
    Map.has_key?(finished_poll_requests, poll_request)
  end

  defp all_poll_requests_finished?(%__MODULE__{} = data) do
    Enum.all?(data.poll_requests, &already_has_response?(data, &1))
  end

  defp build_poll_request_data(%{reimbursement_amounts: [old_amount], payor: payor}) do
    struct!(PollRequestData, payor: payor, old_amount: old_amount)
  end

  defp request_refresh_from_payors(%{procedure_name: procedure_name, poll_requests: poll_requests}) do
    Logger.debug("Sending to #{length(poll_requests)} payors for #{procedure_name}")

    Enum.each(poll_requests, fn poll_request ->
      spawn(fn ->
        # callback = build_response_callback(procedure_name)
        callback = &response_received(procedure_name, &1)

        PayorProcedureRefresher.async_refresh(poll_request, callback)
      end)
    end)
  end

  defp persist_responses(%{finished_poll_requests: finished_poll_requests} = data) do
    spawn(fn ->
      saved_new_amounts =
        Enum.map(finished_poll_requests, fn {poll_req, new_amount} ->
          Reimbursements.replace_reimbursement_amount(poll_req.old_amount, %{amount: new_amount})
        end)

      GenStateMachine.cast(
        {:global, {__MODULE__, data.procedure_name}},
        {:all_persisted, saved_new_amounts}
      )
    end)
  end
end
