defmodule FanCan.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :author, :binary_id, null: false
      add :content, :text, null: false
      add :upvotes, :integer, null: false, default: 0
      add :downvotes, :integer, null: false, default: 0
      add :thread_id, references(:threads, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:id])
  end
end
