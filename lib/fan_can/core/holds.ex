defmodule FanCan.Core.Holds do
  use Ecto.Schema
  import Ecto.Changeset
  alias FanCan.Core.Utils
  
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "holds" do
    field :user_id, :binary_id
    field :hold_cat_id, :binary_id
    field :hold_cat, Ecto.Enum, values: Utils.hold_cats
    field :type, Ecto.Enum, values: Utils.hold_types
    field :active, :boolean

    timestamps()
  end

  @doc false
  def changeset(holds, attrs) do
    holds
    |> cast(attrs, [:id, :user_id, :type, :hold_cat_id, :hold_cat])
    |> validate_required([:id, :user_id, :type, :hold_cat_id, :hold_cat])
    |> unique_constraint(:id)
  end
end
