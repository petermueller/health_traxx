defmodule HealthTraxx.Repo.Migrations.AddExternalIdToPayorProcedure do
  use Ecto.Migration

  def change do
    alter table(:payors_procedures) do
      add :external_id, :string, null: false
    end
  end
end
