defmodule FanCan.Site.Forum.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :author, :binary_id
    field :content, :string
    field :upvotes, :integer
    field :downvotes, :integer
    field :title, :string
    field :thread_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :author, :content, :upvotes, :downvotes, :thread_id])
    |> validate_required([:title, :author, :content, :thread_id])
    |> validate_length(:title, max: 150)
    |> validate_length(:content, max: 500)
  end
end
