defmodule FanCan.Public.Election.Race do
  use Ecto.Schema
  import Ecto.Changeset
  alias FanCan.Core.Utils

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "races" do
    # has_many(:candidates, Candidate)
    field :attachments, {:array, :binary_id}
    field :candidates, {:array, :binary_id}

    belongs_to :candidate_one_fk, FanCan.Public.Candidate, foreign_key: :candidate_one, type: :binary_id
    belongs_to :candidate_two_fk, FanCan.Public.Candidate, foreign_key: :candidate_two, type: :binary_id
    # field :election_id, :binary_id
    belongs_to :elections, Cauldron.Site.Election, foreign_key: :election_id, type: :binary_id
    field :district, :string
    # field :shares, :integer
    # field :bookmarks, :integer
    # field :alerts, :integer
    field :elect_percentage, :float
    field :seat, Ecto.Enum, values: Utils.seats
    belongs_to :elect_fk, FanCan.Public.Candidate, foreign_key: :elect, type: :binary_id
    # field :elect, :binary_id
    timestamps()
  end

  @doc false
  def changeset(race, attrs) do
    race
    |> cast(attrs, [:id, :candidates, :seat, :elect_percentage, :district, :attachments])
    |> validate_required([:candidates, :seat, :elect_percentage, :district, :attachments])
  end
end
