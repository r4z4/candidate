defmodule FanCan.Core.Attachment do
  use Ecto.Schema
  import Ecto.Changeset
  alias FanCan.Core.Utils
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "attachments" do
    field :data, :binary
    field :path, :string
    field :title, :string
    field :type, Ecto.Enum, values: Utils.attachment_types

    timestamps()
  end

  @doc false
  def changeset(attachments, attrs) do
    attachments
    |> cast(attrs, [:title, :path, :data])
    |> validate_required([:title, :path, :data])
  end
end
