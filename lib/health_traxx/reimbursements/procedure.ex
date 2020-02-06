defmodule HealthTraxx.Reimbursements.Procedure do
  use Ecto.Schema
  import Ecto.Changeset

  alias HealthTraxx.Reimbursements.PayorProcedure

  schema "procedures" do
    field(:name, :string)

    has_many(:payor_procedures, PayorProcedure)
    has_many(:payors, through: [:payor_procedures, :payor])

    timestamps()
  end

  def changeset(procedure, attrs) do
    procedure
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
