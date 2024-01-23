defmodule FanCan.Repo.Migrations.CreateThreads do
  use Ecto.Migration

  def change do
    create table(:threads, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :creator, :binary_id
      add :content, :text
      add :likes, :integer, null: false, default: 0
      add :shares, :integer, null: false, default: 0
      add :forum_id, references(:forums, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:threads, [:id])
  end
end
