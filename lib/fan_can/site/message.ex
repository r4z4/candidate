defmodule FanCan.Site.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias FanCan.Repo
  alias FanCan.Core.Utils


  @primary_key {:id, UUIDv7, autogenerate: true}
  schema "messages" do
    field :to, :binary_id
    field :from, :binary_id
    field :subject, :string
    field :type, Ecto.Enum, values: Utils.message_type
    field :text, :string
    field :read, :boolean
    field :saved, :boolean

    timestamps(only: :updated_at)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:id, :to, :from, :subject, :type, :text, :read, :saved])
    |> validate_required([:to, :from, :id, :type])
  end
end