defmodule FanCan.Repo.Migrations.CreateElections do
  use Ecto.Migration

  def change do
    create table(:elections, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :year, :integer
      add :state, :string
      add :desc, :string
      add :election_date, :date

      timestamps()
    end
  end
end
