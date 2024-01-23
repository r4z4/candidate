defmodule FanCan.Repo.Migrations.CreateLegislators do
  use Ecto.Migration

  def change do
    create table(:legislators, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :people_id, :integer
      add :person_hash, :string
      add :party_id, :string
      add :state_id, :integer
      add :party, :string
      add :role_id, :integer
      add :role, :string
      add :name, :string
      add :first_name, :string
      add :middle_name, :string
      add :last_name, :string
      add :suffix, :string
      add :nickname, :string
      add :district, :string
      add :ftm_eid, :integer
      add :votesmart_id, :integer
      add :opensecrets_id, :string
      add :knowwho_pid, :integer
      add :ballotpedia, :string
      add :bioguide_id, :string
      add :committee_sponsor, :integer
      add :committee_id, :integer
      add :state_federal, :integer

      timestamps(null: true)
    end
    # Add index for people_id too?
    create index(:legislators, [:id])
  end
end
