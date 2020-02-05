defmodule HealthTraxx.Reimbursements.Payor do
  use Ecto.Schema
  import Ecto.Changeset

  alias HealthTraxx.Reimbursements.Procedure
  alias HealthTraxx.Reimbursements.PayorProcedure

  schema "payors" do
    field(:name, :string)

    many_to_many(:procedures, Procedure, join_through: PayorProcedure)

    timestamps()
  end

  def changeset(payor, attrs) do
    payor
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
