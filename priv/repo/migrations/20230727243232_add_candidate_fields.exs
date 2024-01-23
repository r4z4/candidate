defmodule FanCan.Repo.Migrations.AddCandidateFields do
  use Ecto.Migration

  def change do
    alter table(:candidates) do
      add :img_url, :string, null: true
      add :bio_url, :string, null: true
      add :city, :string, null: true
      add :phone, :string, null: true
      add :email, :string, null: true
    end
  end
end