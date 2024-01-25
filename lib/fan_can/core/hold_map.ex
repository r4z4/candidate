defmodule FanCan.Core.HoldMap do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hold_map" do
    field :candidate_holds, {:array, :map}
    field :election_holds, {:array, :map}
    field :race_holds, {:array, :map}
    field :user_holds, {:array, :map}
    field :thread_holds, {:array, :map}
    field :post_holds, {:array, :map}
  end

  @doc false
  def changeset(hold_map, attrs) do
    hold_map
    |> cast(attrs, [:candidate_holds, :election_holds, :race_holds, :user_holds, :thread_holds, :post_holds])
    |> validate_required([:candidate_holds, :election_holds, :race_holds, :user_holds, :thread_holds, :post_holds])
  end
end
