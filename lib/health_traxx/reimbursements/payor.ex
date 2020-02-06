defmodule HealthTraxx.Reimbursements.Payor do
  use Ecto.Schema
  import Ecto.Changeset

  alias HealthTraxx.Reimbursements.PayorProcedure

  schema "payors" do
    field(:name, :string)

    has_many(:payor_procedures, PayorProcedure)
    has_many(:procedures, through: [:payor_procedures, :procedure])

    timestamps()
  end

  def changeset(payor, attrs) do
    payor
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
