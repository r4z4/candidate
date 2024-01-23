defmodule FanCan.Repo.Migrations.CreateLegislatorsJson do
  use Ecto.Migration

  def change do
    create table(:legislators_json, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :api_map, :map, default: %{}

      timestamps(null: true)
    end
    # Add index for people_id too?
    create index(:legislators_json, [:id])
  end
end
