defmodule FanCan.Repo.Migrations.CreateCandidates do
  use Ecto.Migration

  def change do
    create table(:candidates, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :prefix, :string
      add :f_name, :string
      add :l_name, :string
      add :suffix, :string
      add :state, :string
      add :birth_state, :string
      add :district, :integer
      add :end_date, :date
      # Enums in Schema just strings in DB
      add :seat, :string
      add :party, :string
      add :cpvi, :string
      add :incumbent_since, :date
      add :dob, :date
      add :education, {:array, :string}
      add :attachments, {:array, :binary_id}

      timestamps(null: true)
    end
  end
end
