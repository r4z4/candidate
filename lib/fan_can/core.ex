defmodule FanCan.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias FanCan.Repo

  alias FanCan.Core.Attachment

  @doc """
  Gets a single attachment.

  Raises `Ecto.NoResultsError` if the Attachment does not exist.

  ## Examples

      iex> get_attachment!(123)
      %Candidate{}

      iex> get_attachment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_attachment!(id), do: Repo.get!(Attachment, id)
end