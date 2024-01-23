defmodule FanCan.Repo.Migrations.CreateAuthorize do
  use Ecto.Migration

  def change do
    create table(:authorize, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :role, :string
      add :read, :map, default: %{}
      add :create, :map, default: %{}
      add :edit, :map, default: %{}
      add :delete, :map, default: %{}

      timestamps()
    end
  end
end