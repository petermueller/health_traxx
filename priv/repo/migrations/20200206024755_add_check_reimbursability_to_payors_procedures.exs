defmodule HealthTraxx.Repo.Migrations.AddCheckReimbursabilityToPayorsProcedures do
  use Ecto.Migration

  def change do
    alter table(:payors_procedures) do
      add :check_reimbursability, :boolean, default: true
    end
  end
end
