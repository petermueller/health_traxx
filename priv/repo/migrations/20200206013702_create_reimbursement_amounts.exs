defmodule HealthTraxx.Repo.Migrations.CreateReimbursementAmounts do
  use Ecto.Migration

  def change do
    create table(:reimbursement_amounts) do
      add :amount, :decimal, null: false
      add :payor_procedure_id, references(:payors_procedures, on_delete: :restrict), null: false
      add :replaced_at, :utc_datetime_usec

      timestamps()
    end
  end
end
