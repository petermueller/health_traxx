require Logger

defmodule HealthTraxx.ProcedurePolling.PayorProcedureRefresher do
  def async_refresh(%{old_amount: %{amount: amount}} = poll_request_data, callback) do
    # TODO - call to a FakeClient (also build a FakeClient)
    new_amount =
      if Decimal.gt?(amount, 100) do
        Decimal.add(amount, 100)
      else
        amount
      end

    callback.({poll_request_data, new_amount})
  end
end
