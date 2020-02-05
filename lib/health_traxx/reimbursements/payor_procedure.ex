defmodule HealthTraxx.Reimbursements.PayorProcedure do
  use Ecto.Schema
  import Ecto.Changeset

  alias HealthTraxx.Reimbursements.Payor
  alias HealthTraxx.Reimbursements.Procedure

  schema "payors_procedures" do
    belongs_to :payor, Payor
    belongs_to :procedure, Procedure

    timestamps()
  end

  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:payor_id, :procedure_id])
    |> validate_required([:payor_id, :procedure_id])
  end
end
