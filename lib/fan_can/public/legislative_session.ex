defmodule FanCan.Public.LegislativeSession do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :session_id, :integer
    field :state_id, :integer
    field :year_start, :integer
    field :year_end, :integer
    field :prefile, :integer
    field :sine_die, :integer
    field :prior, :integer
    field :special, :integer
    field :session_tag, :string
    field :session_title, :string
    field :session_name, :string
    field :dataset_hash, :string
    field :session_hash, :string
    field :name, :string
  end

  @doc false
  def changeset(legislative_session, attrs) do
    legislative_session
    |> cast(attrs, [:session_id, :state_id, :year_start, :year_end, :prefile, :sine_die, :prior, :special, :session_tag, :session_title, :session_name, :dataset_hash, :session_hash, :name])
    |> validate_required([:session_id])
  end
end