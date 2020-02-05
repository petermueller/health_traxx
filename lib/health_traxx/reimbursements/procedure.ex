defmodule HealthTraxx.Reimbursements.Procedure do
  use Ecto.Schema
  import Ecto.Changeset

  alias HealthTraxx.Reimbursements.Payor
  alias HealthTraxx.Reimbursements.PayorProcedure

  schema "procedures" do
    field(:name, :string)

    many_to_many(:payors, Payor, join_through: PayorProcedure)

    timestamps()
  end

  def changeset(procedure, attrs) do
    procedure
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
