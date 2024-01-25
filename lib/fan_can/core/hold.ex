defmodule FanCan.Core.Hold do
  @behaviour Ecto.Type
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
  def changeset(hold, attrs) do
    hold
    |> cast(attrs, [:id, :user_id, :type, :hold_cat_id, :hold_cat])
    |> validate_required([:id, :user_id, :type, :hold_cat_id, :hold_cat])
    |> unique_constraint(:id)
  end

  @type t :: %__MODULE__{
    __meta__: Ecto.Schema.Metadata.t(),
    user_id: Ecto.UUID.t(),
    hold_cat_id: Ecto.UUID.t(),
    hold_cat: String.t(),
    type: String.t(),
    active: Boolean.t()
  }
end
