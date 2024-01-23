defmodule FanCan.Public.LegislatorJson do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "legislators_json" do
    field :api_map, :map
  end

  @doc false
  def changeset(legislator, attrs) do
    legislator
    |> cast(attrs, [:id, :api_map])
    |> validate_required([:api_map])
  end
end


# Simple case for query. And with Ecto, done with fragment. Query for the product where color is black.
#import Ecto.Query, warn: false
#alias Tutorial.Repo
#alias Tutorial.Products.Product
#(from p in Product, where: fragment("? ->> ? = ?", p.properties, "color", "black"))
#|> Repo.all