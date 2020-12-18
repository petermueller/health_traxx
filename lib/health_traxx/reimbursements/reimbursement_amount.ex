defmodule HealthTraxx.Reimbursements.ReimbursementAmount do
  use Ecto.Schema
  import Ecto.Changeset

  alias HealthTraxx.Reimbursements.PayorProcedure

  schema "reimbursement_amounts" do
    field(:amount, :decimal)
    field(:replaced_at, :utc_datetime_usec)

    belongs_to(:payor_procedure, PayorProcedure)

    timestamps()
  end

  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:amount, :payor_procedure_id, :replaced_at])
    |> validate_required([:amount, :payor_procedure_id])
  end
end
