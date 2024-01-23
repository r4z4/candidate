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
    field :election_id, :binary_id
    field :district, :string
    # field :shares, :integer
    # field :bookmarks, :integer
    # field :alerts, :integer
    field :elect_percentage, :float
    field :seat, Ecto.Enum, values: Utils.seats
    field :elect, :binary_id
    timestamps()
  end

  @doc false
  def changeset(race, attrs) do
    race
    |> cast(attrs, [:id, :candidates, :seat, :elect_percentage, :district, :attachments])
    |> validate_required([:candidates, :seat, :elect_percentage, :district, :attachments])
  end
end
