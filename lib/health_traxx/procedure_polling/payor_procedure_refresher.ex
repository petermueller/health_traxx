defmodule HealthTraxx.ProcedurePolling.PayorProcedureRefresher do
  def refresh(_procedure_name, _payor) do
    # TODO - call to a FakeClient (also build a FakeClient)
    "new reimbursement amount!"
  end
end
