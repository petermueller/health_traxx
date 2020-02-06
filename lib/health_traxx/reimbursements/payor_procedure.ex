defmodule HealthTraxx.Reimbursements.PayorProcedure do
  use Ecto.Schema
  import Ecto.Changeset

  alias HealthTraxx.Reimbursements.{Payor, Procedure, ReimbursementAmount}

  schema "payors_procedures" do
    field :external_id, :string
    field :check_reimbursability, :boolean

    belongs_to :payor, Payor
    belongs_to :procedure, Procedure
    has_many :reimbursement_amounts, ReimbursementAmount

    timestamps()
  end

  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:payor_id, :procedure_id, :external_id, :check_reimbursability])
    |> validate_required([:payor_id, :procedure_id, :external_id])
    |> unique_constraint(:payor_id, name: :payors_procedures_payor_id_procedure_id_index)
  end
end
