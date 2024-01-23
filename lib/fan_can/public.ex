defmodule FanCan.Public do
  @moduledoc """
  The Public context.
  """

  import Ecto.Query, warn: false
  alias FanCan.Repo

  alias FanCan.Public.{Legislator, LegislatorJson, Candidate}
  alias FanCan.Public.Election.Race
  alias FanCan.Core.Utils

  @doc """
  Returns the list of candidates.

  ## Examples

      iex> list_candidates()
      [%Candidate{}, ...]

  """
  def list_candidates(params \\ []) do
    Repo.all(Candidate)
    |> order_by(desc: :updated_at)
  end

  @doc """
  Returns paginated list of candidates.

  ## Examples

      iex> paginate_candidates()
      [%Candidate{entries: }, ...]

  """

  def paginate_candidates(params \\ []) do
    Candidate
    |> order_by(desc: :updated_at)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single candidate.

  Raises `Ecto.NoResultsError` if the Candidate does not exist.

  ## Examples

      iex> get_candidate!(123)
      %Candidate{}

      iex> get_candidate!(456)
      ** (Ecto.NoResultsError)

  """
  def get_candidate!(id), do: Repo.get!(Candidate, id)

  @doc """
  Creates a candidate.

  ## Examples

      iex> create_candidate(%{field: value})
      {:ok, %Candidate{}}

      iex> create_candidate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_candidate(attrs \\ %{}) do
    %Candidate{}
    |> Candidate.changeset(attrs)
    |> Repo.insert()
  end

  def create_legislator(attrs \\ %{}) do
    %Legislator{}
    |> Legislator.changeset(attrs)
    |> Repo.insert()
  end

  def create_legislator_json(attrs \\ %{}) do
    %LegislatorJson{}
    |> LegislatorJson.changeset(attrs)
    |> Repo.insert()
  end

  def list_legislators(state) do
    state_id = 
      Enum.with_index(Utils.states)
      |> Enum.find(fn {x,y} -> x == state end)
      |> Kernel.elem(1)
      |> Kernel.+(1)
    query =
      from l in Legislator,
      where: l.state_id == ^state_id,
      # & type = :vote
      select: l
    state_legislators = FanCan.Repo.all(query)
  end

  def create_leg_ballot_races(race_list \\ []) do
    case Repo.insert_all(Race, race_list, returning: true) do
      {id, race_list} -> {:ok, id}
      {:error, _} -> IO.puts("RACE LIST Error")
    end
  end

  def create_legislators(list \\ []) do
    # IO.inspect(list, label: "Query list")
    Repo.insert_all(Legislator, list, returning: true)
  end

  def state_records_exist?(state) do
    # Legiscan IDs alphabetical
    state_id = 
      Enum.with_index(Utils.states)
      |> Enum.find(fn {x,y} -> x == state end)
      |> Kernel.elem(1)
      |> Kernel.+(1)
    result = Repo.exists?(from l in Legislator, where: l.state_id == ^state_id)
    Repo.exists?(from l in Legislator, where: l.state_id == ^state_id)
  end

  @doc """
  Gets the current mayor for the user's city and state.

  ## Examples

      iex> create_candidate(%{field: value})
      {:ok, %Candidate{}}

      iex> create_candidate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def get_mayor(city \\ "", state \\ "") do
    query =
      from c in Candidate,
      where: c.city == ^city,
      where: c.state == ^state,
      # & type = :vote
      select: c
    mayor = FanCan.Repo.one(query)
  end

  @doc """
  Updates a candidate.

  ## Examples

      iex> update_candidate(candidate, %{field: new_value})
      {:ok, %Candidate{}}

      iex> update_candidate(candidate, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_candidate(%Candidate{} = candidate, attrs) do
    candidate
    |> Candidate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a candidate.

  ## Examples

      iex> delete_candidate(candidate)
      {:ok, %Candidate{}}

      iex> delete_candidate(candidate)
      {:error, %Ecto.Changeset{}}

  """
  def delete_candidate(%Candidate{} = candidate) do
    Repo.delete(candidate)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking candidate changes.

  ## Examples

      iex> change_candidate(candidate)
      %Ecto.Changeset{data: %Candidate{}}

  """
  def change_candidate(%Candidate{} = candidate, attrs \\ %{}) do
    Candidate.changeset(candidate, attrs)
  end

  alias FanCan.Public.Election

  @doc """
  Returns the list of elections.

  ## Examples

      iex> list_elections()
      [%Election{}, ...]

  """
  def list_elections do
    Repo.all(Election)
  end

    @doc """
  Returns the list of elections.

  ## Examples

      iex> list_elections()
      [%Election{}, ...]

  """
  def list_elections_and_ballots do
    elections = Repo.all(Election)
    final_elections = 
      for election <- elections do
        # ballot_ids = Election.get_ballot_ids_by_election_id(election.id)
        ballots = Election.get_ballots_by_election_id(election.id)
        # IO.inspect(ballot_ids, label: "ballot_ids")
        new = Map.put(election, :ballots, ballots)
      end
  end

  @doc """
  Gets a single election.

  Raises `Ecto.NoResultsError` if the Election does not exist.

  ## Examples

      iex> get_election!(123)
      %Election{}

      iex> get_election!(456)
      ** (Ecto.NoResultsError)

  """
  def get_election!(id), do: Repo.get!(Election, id)

  @doc """
  Creates a election.

  ## Examples

      iex> create_election(%{field: value})
      {:ok, %Election{}}

      iex> create_election(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_election(attrs \\ %{}) do
    %Election{}
    |> Election.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a election.

  ## Examples

      iex> update_election(election, %{field: new_value})
      {:ok, %Election{}}

      iex> update_election(election, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_election(%Election{} = election, attrs) do
    election
    |> Election.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a election.

  ## Examples

      iex> delete_election(election)
      {:ok, %Election{}}

      iex> delete_election(election)
      {:error, %Ecto.Changeset{}}

  """
  def delete_election(%Election{} = election) do
    Repo.delete(election)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking election changes.

  ## Examples

      iex> change_election(election)
      %Ecto.Changeset{data: %Election{}}

  """
  def change_election(%Election{} = election, attrs \\ %{}) do
    Election.changeset(election, attrs)
  end

  alias FanCan.Public.State

  @doc """
  Returns the list of states.

  ## Examples

      iex> list_states()
      [%State{}, ...]

  """
  def list_states do
    Repo.all(State)
  end

  @doc """
  Gets a single state.

  Raises `Ecto.NoResultsError` if the State does not exist.

  ## Examples

      iex> get_state!(123)
      %State{}

      iex> get_state!(456)
      ** (Ecto.NoResultsError)

  """
  def get_state!(id), do: Repo.get!(State, id)

  @doc """
  Creates a state.

  ## Examples

      iex> create_state(%{field: value})
      {:ok, %State{}}

      iex> create_state(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_state(attrs \\ %{}) do
    %State{}
    |> State.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a state.

  ## Examples

      iex> update_state(state, %{field: new_value})
      {:ok, %State{}}

      iex> update_state(state, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_state(%State{} = state, attrs) do
    state
    |> State.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a state.

  ## Examples

      iex> delete_state(state)
      {:ok, %State{}}

      iex> delete_state(state)
      {:error, %Ecto.Changeset{}}

  """
  def delete_state(%State{} = state) do
    Repo.delete(state)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking state changes.

  ## Examples

      iex> change_state(state)
      %Ecto.Changeset{data: %State{}}

  """
  def change_state(%State{} = state, attrs \\ %{}) do
    State.changeset(state, attrs)
  end
end
