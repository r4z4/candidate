defmodule FanCan.Repo.Migrations.CreateStates do
  use Ecto.Migration

  def change do
    create table(:states, primary_key: false) do
      add :id, :integer, primary_key: true
      add :name, :string
      add :code, :string
      add :num_districts, :integer
      add :governor, references(:candidates, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:states, [:governor])
  end
end
