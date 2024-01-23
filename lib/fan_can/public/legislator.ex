defmodule FanCan.Public.Legislator do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "legislators" do
    field :people_id, :integer
    field :person_hash, :string
    field :party_id, :string
    field :state_id, :integer
    field :party, :string
    field :role_id, :integer
    field :role, :string
    field :name, :string
    field :first_name, :string
    field :middle_name, :string
    field :last_name, :string
    field :suffix, :string
    field :nickname, :string
    field :district, :string
    field :ftm_eid, :integer
    field :votesmart_id, :integer
    field :opensecrets_id, :string
    field :knowwho_pid, :integer
    field :ballotpedia, :string
    field :bioguide_id, :string
    field :committee_sponsor, :integer
    field :committee_id, :integer
    field :state_federal, :integer
  end

  @doc false
  def changeset(legislator, attrs) do
    legislator
    |> cast(attrs, [:people_id, :person_hash, :party_id, :state_id, :party, :role_id, :name, :first_name, :middle_name, :last_name, :suffix, :nickname, 
                    :district, :ftm_eid, :votesmart_id, :opensecrets_id, :knowwho_pid, :ballotpedia, :bioguide_id, :committee_sponsor, :committee_id, :state_federal])
    |> validate_required([:people_id])
  end
end