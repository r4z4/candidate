defmodule FanCan.Repo.Migrations.CreateForums do
  use Ecto.Migration

  def change do
    create table(:forums, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :desc, :string
      add :category, :string
      # Subscribers and Members are different
      add :members, {:array, :binary_id}, null: false, default: []
      add :moderator, references(:users, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:forums, [:id])
  end
end
