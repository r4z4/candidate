defmodule FanCan.Repo.Migrations.CreateBallots do
  use Ecto.Migration

  def change do
    create table(:ballots, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing)
      add :columns, :integer
      add :vote_map, :map, default: %{}
      add :submitted, :boolean, null: false, default: false
      add :attachment, references(:attachments, type: :binary_id, on_delete: :nothing)
      add :election_id, references(:elections, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:ballots, [:id])
  end
end
