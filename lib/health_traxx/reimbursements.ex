defmodule HealthTraxx.Reimbursements do
  import Ecto.Query, warn: false

  alias HealthTraxx.Repo
  alias HealthTraxx.Reimbursements.{Procedure, PayorProcedure, ReimbursementAmount}

  def list_procedures_with_payors do
    from(procedures in Procedure,
      join: payors in assoc(procedures, :payors),
      preload: [:payors],
      distinct: true
    )
    |> Repo.all()
  end

  def list_current_reimbursable_procedure_amounts do
    from(procedures in Procedure,
      join: pay_procs in assoc(procedures, :payor_procedures),
      join: payors in assoc(pay_procs, :payor),
      left_join: amounts in assoc(pay_procs, :reimbursement_amounts),
      where: pay_procs.check_reimbursability == true,
      where: is_nil(amounts.replaced_at),
      preload: [payor_procedures: {pay_procs, reimbursement_amounts: amounts, payor: payors}]
    )
    |> Repo.all()
  end

  def create_payor_procedure!(attrs \\ %{}) do
    %PayorProcedure{}
    |> PayorProcedure.changeset(attrs)
    |> Repo.insert!()
  end

  def create_reimbursement_amount!(attrs \\ %{}) do
    %ReimbursementAmount{}
    |> ReimbursementAmount.changeset(attrs)
    |> Repo.insert!()
  end

  def replace_reimbursement_amount(%ReimbursementAmount{} = old_amount, attrs \\ %{}) do
    ReimbursementAmount.changeset(old_amount, %{replaced_at: DateTime.utc_now()})
    |> Repo.update!()

    Map.put(attrs, :payor_procedure_id, old_amount.payor_procedure_id)
    |> create_reimbursement_amount!()
  end
end
