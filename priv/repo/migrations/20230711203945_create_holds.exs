defmodule FanCan.Repo.Migrations.CreateHolds do
  use Ecto.Migration

  def change do
    create table(:holds, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :type, :string, null: false
      add :hold_cat_id, :binary_id, null: false
      add :hold_cat, :string, null: false
      # Most common case is adding a hold = default to true
      add :active, :boolean, null: false, default: true

      timestamps()
    end
    create index(:holds, [:id])
    create unique_index(:holds, [:user_id, :type, :hold_cat_id, :hold_cat], name: :holds_u_index)
  end
end
