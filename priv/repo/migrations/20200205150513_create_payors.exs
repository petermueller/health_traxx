defmodule HealthTraxx.Repo.Migrations.CreatePayors do
  use Ecto.Migration

  def change do
    create table(:payors) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:payors, [:name])
  end
end
