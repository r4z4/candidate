defmodule FanCan.Accounts.Authorize do
  alias __MODULE__
  use Ecto.Schema
  import Ecto.Changeset
  alias FanCan.Core.Utils
  alias FanCan.Public.Candidate
  alias FanCan.Accounts.User
  alias FanCan.Repo
  import Ecto.Query, warn: false
  
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "authorize" do
    field :role, Ecto.Enum, values: Utils.roles
    field :read, :map
    field :create, :map
    field :edit, :map
    field :delete, :map

    timestamps()
  end

  def get_permissions(role) do
    query = from a in Authorize,
      where: a.role == ^role,
      select: a
    FanCan.Repo.one(query)
  end

  # def can(:reader = role) do
  #   grant(role)
  #   |> read(:candidate)
  # end

  # def can(:voter = role) do
  #   grant(role)
  #   |> read(:candidate)
  #   |> read(:user)
  # end

  # def can(:admin = role) do
  #   grant(role)
  #   |> all(:candidate)
  #   |> all(:user)
  # end
  def create(auth, resource), do: put_action(auth, :create, resource)
  def read(auth, resource), do: put_action(auth, :read, resource)
  def edit(auth, resource), do: put_action(auth, :update, resource)
  def delete(auth, resource), do: put_action(auth, :delete, resource)

  # guard or case (do i want an error)
  def update_auth(auth, action, resource) do
    if resource in Utils.resources do
      case action do
        :create -> create(auth, resource)
        :edit -> edit(auth, resource)
        :read -> read(auth, resource)
        :delete -> delete(auth, resource)
      end
    else
      raise "Invalid Resource"
    end
  end

  # e.g. can :voter 
  def grant(role, action, resource) when is_atom(action) and is_atom(resource) do
    get_permissions(role)
    |> update_auth(action, resource)
  end

  # def can(:candidate = role, action) do
  #   grant(role)
  #   |> case action do
  #     :create -> create(:candidate)
  #     :edit -> edit(:candidate)
  #     :read -> read(:candidate)
  #     :delete -> delete(:candidate)
  #   end
  # end

  def all(auth, resource) do
    auth
    |> read(resource)
    |> create(resource)
    |> edit(resource)
    |> delete(resource)
  end
  # default to false if key does not exist
  def read?(auth, resource) do
    Map.get(auth.read, Atom.to_string(resource), false)
  end
  def create?(auth, resource) do
    Map.get(auth.create, Atom.to_string(resource), false)
  end
  def edit?(auth, resource) do
    IO.inspect(auth, label: "Edit Auth")
    Map.get(auth.edit, Atom.to_string(resource), false)
  end
  # e.g. can they delete a :candidate
  def delete?(auth, resource) do
    Map.get(auth.delete, Atom.to_string(resource), false)
  end

  defp put_action(auth, action, resource) do
    IO.inspect(auth, label: "Auth")
    IO.inspect(action, label: "Action")
    IO.inspect(resource, label: "Rescource")
    # e.g. putting create: true into the struct in the read/create/update block
    updated_action =
      auth
      |> Map.get(action)
      |> Map.put(Atom.to_string(resource), true)
    IO.inspect(updated_action, label: "Updated Action")
    Map.put(auth, action, updated_action)
  end
end