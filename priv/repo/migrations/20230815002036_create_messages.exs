defmodule FanCan.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :to, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :from, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :subject, :string
      add :type, :string, null: false
      add :text, :string
      # Most common case is adding a hold = default to true
      add :read, :boolean, null: false, default: false
      add :saved, :boolean, null: false, default: false

      timestamps(only: :updated_at)
    end
    create index(:messages, [:id])
  end
end
