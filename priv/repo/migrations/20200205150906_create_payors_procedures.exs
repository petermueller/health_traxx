defmodule HealthTraxx.Repo.Migrations.CreatePayorsProcedures do
  use Ecto.Migration

  def change do
    create table(:payors_procedures) do
      add :payor_id,     references(:payors, on_delete: :restrict), null: false
      add :procedure_id, references(:procedures, on_delete: :restrict), null: false

      timestamps()
    end

    create unique_index(:payors_procedures, [:payor_id, :procedure_id])
  end
end
