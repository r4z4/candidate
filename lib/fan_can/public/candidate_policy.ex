defmodule FanCan.Public.CandidatePolicy do
  use Ecto.Schema
  import Ecto.Changeset
  alias FanCan.Core.Utils
  
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "candidate_policy" do
    field :policy_embedding, Pgvector.Ecto.Vector
    timestamps()
  end

  @doc false
  def changeset(candidate, attrs) do
    candidate
    |> cast(attrs, [:id, :policy_embedding])
    |> validate_required([:id, :policy_embedding])
  end
end
