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
      preload: [payors: payors, payor_procedures: {pay_procs, reimbursement_amounts: amounts}]
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
end
