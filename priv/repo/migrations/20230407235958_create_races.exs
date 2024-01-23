defmodule FanCan.Repo.Migrations.CreateRaces do
  use Ecto.Migration

  def change do
    create table(:races, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :candidates, {:array, :binary_id}
      add :seat, :string
      add :election_id, references(:elections, type: :binary_id, on_delete: :nothing)
      add :elect_percentage, :float
      add :district, :string
      add :attachments, {:array, :binary_id}
      add :elect, references(:candidates, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:races, [:elect])
  end
end
