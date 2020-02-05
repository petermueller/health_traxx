defmodule HealthTraxx.Reimbursements do
  import Ecto.Query, warn: false

  alias HealthTraxx.Repo
  alias HealthTraxx.Reimbursements.Procedure

  def list_procedures_with_payors do
    from(procedures in Procedure,
      join: payors in assoc(procedures, :payors),
      preload: [:payors],
      distinct: true
    )
    |> Repo.all()
  end
end
