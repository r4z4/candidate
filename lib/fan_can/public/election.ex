defmodule FanCan.Public.Election do
  use Ecto.Schema
  import Ecto.Changeset
  alias FanCan.Core.Utils
  alias FanCan.Public
  alias FanCan.Accounts

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "elections" do
    field :desc, :string
    field :election_date, :date
    field :state, Ecto.Enum, values: Utils.states
    field :year, :integer

    timestamps()
  end

  @doc false
  def changeset(election, attrs) do
    election
    |> cast(attrs, [:year, :state, :desc, :election_date])
    |> validate_required([:year, :state, :desc])
  end

  alias FanCan.Public.{Election, Candidate, Legislator}
  alias FanCan.Core.Hold
  alias FanCan.Accounts.{UserHolds, User, UserToken}
  alias FanCan.Public.Election.{RaceHolds, Ballot, Race, ElectionHolds, CandidateHolds}
  import Ecto.Query, warn: false
  alias FanCan.Repo

  @type ballot_map :: %{
   id: binary,
   year: integer,
   district: integer,
   candidates: [%Candidate{}],
   election_date: %Date{},
   desc: String.t,
   seat: atom,
   state: atom,
   inserted_at: %NaiveDateTime{},
   updated_at: %NaiveDateTime{},
}

  @spec get_ballot_races(binary) :: [ballot_map]
  def get_ballot_races(ballot_id) do
    query = from r in Race,
      join: e in Election,
      on: r.election_id == e.id,
      join: b in Ballot,
      on: b.election_id == e.id,
      where: b.id == ^ballot_id,
      # where: r.district != "",
      order_by: [asc: r.district],
      # FIXME Change this to confirmed_at > inserted_at
      # Or can do "id" => r.id, "candidates" => .... then access via ballot_race["id"] in template.
      select: %{:id => r.id, :candidates => r.candidates, :seat => r.seat, :district => r.district, :election_id => e.id, :desc => "Legislator ballot race"}
      # select: {u.username, u.email, u.inserted_at, us.easy_games_played, us.easy_games_finished, us.med_games_played, us.med_games_finished, us.hard_games_played, us.hard_games_finished,
      #           us.easy_poss_pts, us.easy_earned_pts, us.med_poss_pts, us.med_earned_pts, us.hard_poss_pts, us.hard_earned_pts}
      # distinct: p.id
      # where: u.age > type(^age, :integer)
    FanCan.Repo.all(query)
  end

  def get_candidates(race_id) do
    query = from r in Race,
      join: c1 in Candidate, on: c1.candidate_id == r.candidate_one,
      join: c2 in Candidate, on: c2.candidate_id == r.candidate_two,
      where: r.id == ^race_id,
      select: %{candidate_one: c1, candidate_two: c2}
    FanCan.Repo.all(query)
  end

  def get_leg(state_id) do
    query = from l in Legislator,
      where: l.state_id == ^state_id
    FanCan.Repo.all(query)
  end

  def get_mock(state_id) do
    query = from l in Legislator,
      where: l.state_id == 00
    FanCan.Repo.one(query)
  end

  def get_legislators(state_id) do
    real = get_leg(state_id)
    length = Kernel.length(real)
    mock = get_mock(state_id)
    # mocks = List.duplicate(mock, length)
    [List.first(real), mock]
  end

  def get_legislators_from_ids(id_list) do
    query = from l in Legislator,
      where: l.id in ^id_list
    FanCan.Repo.all(query)
  end

  @doc """
  Returns the list of races.

  ## Examples

      iex> list_races()
      [%Race{}, ...]

  """
  def list_races do
    Repo.all(Race)
  end

  @doc """
  Gets a single race.

  Raises `Ecto.NoResultsError` if the Race does not exist.

  ## Examples

      iex> get_race!(123)
      %Race{}

      iex> get_race!(456)
      ** (Ecto.NoResultsError)

  """
  def get_race!(id), do: Repo.get!(Race, id)

  @doc """
  Creates a race.

  ## Examples

      iex> create_race(%{field: value})
      {:ok, %Race{}}

      iex> create_race(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_race(attrs \\ %{}) do
    %Race{}
    |> Race.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a race.

  ## Examples

      iex> update_race(race, %{field: new_value})
      {:ok, %Race{}}

      iex> update_race(race, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_race(%Race{} = race, attrs) do
    race
    |> Race.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a race.

  ## Examples

      iex> delete_race(race)
      {:ok, %Race{}}

      iex> delete_race(race)
      {:error, %Ecto.Changeset{}}

  """
  def delete_race(%Race{} = race) do
    Repo.delete(race)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking race changes.

  ## Examples

      iex> change_race(race)
      %Ecto.Changeset{data: %Race{}}

  """
  def change_race(%Race{} = race, attrs \\ %{}) do
    Race.changeset(race, attrs)
  end

  alias FanCan.Public.Election.Ballot

  @doc """
  Returns the list of ballots.

  ## Examples

      iex> list_ballots()
      [%Ballot{}, ...]

  """
  def list_ballots do
    Repo.all(Ballot)
  end

  @doc """
  Gets a single ballot.

  Raises `Ecto.NoResultsError` if the Ballot does not exist.

  ## Examples

      iex> get_ballot!(123)
      %Ballot{}

      iex> get_ballot!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ballot!(id), do: Repo.get!(Ballot, id)

  @doc """
  Gets all ballots by election id (usually just one)
  """
  def get_ballot_ids_by_election_id(id) do
    query = from b in Ballot,
      join: e in Election,
      on: b.election_id == e.id,
      where: e.id == ^id,
      select: b.id
    FanCan.Repo.all(query)
  end

  def get_ballots_by_election_id(id) do
    query = from b in Ballot,
      join: e in Election,
      on: b.election_id == e.id,
      where: e.id == ^id,
      select: b
    FanCan.Repo.all(query)
  end
  @doc """
  Creates a ballot.

  ## Examples

      iex> create_ballot(%{field: value})
      {:ok, %Ballot{}}

      iex> create_ballot(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ballot(attrs \\ %{}) do
    %Ballot{}
    |> Ballot.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ballot.

  ## Examples

      iex> update_ballot(ballot, %{field: new_value})
      {:ok, %Ballot{}}

      iex> update_ballot(ballot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ballot(%Ballot{} = ballot, attrs) do
    ballot
    |> Ballot.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ballot.

  ## Examples

      iex> delete_ballot(ballot)
      {:ok, %Ballot{}}

      iex> delete_ballot(ballot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ballot(%Ballot{} = ballot) do
    Repo.delete(ballot)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ballot changes.

  ## Examples

      iex> change_ballot(ballot)
      %Ecto.Changeset{data: %Ballot{}}

  """
  def change_ballot(%Ballot{} = ballot, attrs \\ %{}) do
    Ballot.changeset(ballot, attrs)
  end

  defp extract_key(attrs) do
    Map.drop(attrs, [:id, :type, :user_id])
      |> Map.keys()
      |> List.first()
  end


  @doc """
  Adds user_holds for type :user and admin id for each new user.

  ## Examples

      iex> register_user_holds(%{field: value})
      {:ok, %UserHolds{}}

      iex> register_user_holds(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # DRY
  def register_upvote_downvote(attrs) do
    # For now this'll always just be a post. might not always be though
    case Map.fetch(attrs, :type) do
      {:ok, :upvote} ->
        %Hold{}
          |> Hold.changeset(attrs)
          |> Repo.insert(returning: true)

      {:ok, :downvote} ->
        %Hold{}
          |> Hold.changeset(attrs)
          |> Repo.insert(returning: true)

      _ -> IO.puts("No Match for Upvote Downvote")
    end
  end

  def register_alert(attrs) do
    case Map.fetch(attrs, :hold_cat) do
      {:ok, :race} ->
        %Hold{}
          |> Hold.changeset(attrs)
          |> Repo.insert(returning: true)

      {:ok, :election} ->
        %Hold{}
          |> Hold.changeset(attrs)
          |> Repo.insert(returning: true)

      {:ok,:user} ->
        %Hold{}
        |> Hold.changeset(attrs)
        |> Repo.insert(returning: true)

      _ -> IO.puts("Ooooooooooooooops")
    end
  end

  def register_bookmark(attrs) do
    case Map.fetch(attrs, :hold_cat) do
      {:ok, :race} ->
        %Hold{}
          |> Hold.changeset(attrs)
          |> Repo.insert(returning: true)

      {:ok, :election} ->
        %Hold{}
          |> Hold.changeset(attrs)
          |> Repo.insert(returning: true)
      # Can you bookmark a user? Probably not
      {:ok, :user} ->
        %Hold{}
        |> Hold.changeset(attrs)
        |> Repo.insert(returning: true)

      _ -> IO.puts("Bookmark Ooooooooooooooops")
    end
  end

  def register_hold(attrs) do
    case Map.fetch(attrs, :hold_cat) do
      {:ok, _} ->
        %Hold{}
          |> Hold.changeset(attrs)
          |> Repo.insert(returning: true)

      _ -> IO.puts("No Match on Register Hold")
    end
  end

  def register_vote(attrs) do
    # If hold exists, flip to active. Else, create new.
    query =
      from h in Hold,
      where: h.hold_cat_id == ^attrs.hold_cat_id,
      where: h.hold_cat == ^attrs.hold_cat,
      where: h.type == ^attrs.type,
      select: h
    hold = FanCan.Repo.one(query)

    if hold do
      Accounts.update_hold(hold, %{active: true})
    else
      case Map.fetch(attrs, :hold_cat) do
        {:ok, :candidate} ->
          %Hold{}
            |> Hold.changeset(attrs)
            |> Repo.insert(returning: true)

        _ -> IO.puts("Ooooooooooooooops")
      end
    end
  end

  def register_ballot(attrs) do
    case Map.fetch(attrs, :user_id) do
      {:ok, _} ->
        get_ballot!(attrs.id)
        |> update_ballot(attrs)

      _ -> IO.puts("Ooooooooooooooops Ballot")
    end
  end

  # Have it take a list now to handle multiple unregisters (clearing)
  def unregister_votes(id_list, cat) do
    from(h in Hold, where: h.hold_cat_id in ^id_list, where: h.hold_cat == ^cat, where: h.type == :vote, select: h)
    |> FanCan.Repo.update_all(set: [active: false])
  end

  def get_races(race_hold_ids) do
    query =
      from r in Race,
      where: r.id in ^race_hold_ids,
      # & type = :vote
      select: r
    races = FanCan.Repo.all(query)
  end

  def get_elections(hold_ids) do
    query =
      from e in Election,
      where: e.id in ^hold_ids,
      # & type = :vote
      select: e
    FanCan.Repo.all(query)
  end

  def get_election_id(state, desc) do
    query =
      from e in Election,
      where: e.state == ^state,
      where: e.desc == ^desc,
      # & type = :vote
      select: e.id
    id = FanCan.Repo.one(query)

    if !id do
      attrs = %{id: Ecto.UUID.generate(), desc: desc, state: state, year: 2024}
      case Public.create_election(attrs) do
        {:ok, struct}       -> struct.id
        {:error, changeset} -> IO.inspect(changeset, label: "changeset")
      end
    end
  end

  #   def get_race_holds_by_token(token)
  #     when is_binary(token) do
  #   query = from u in User,
  #       join: ut in UserToken, on: u.id == ut.user_id,
  #       join: rh in RaceHolds, on: u.id == rh.user_id
  #   query = from [u, ut, rh] in query,
  #         where: ut.token == ^token,
  #         select: rh
  #         # Repo.all returns a list
  #   Repo.all(query)
  # end

  # def get_election_holds_by_token(token)
  #     when is_binary(token) do
  #   query = from u in User,
  #       join: ut in UserToken, on: u.id == ut.user_id,
  #       join: eh in ElectionHolds, on: u.id == eh.user_id
  #   query = from [u, ut, eh] in query,
  #         where: ut.token == ^token,
  #         select: eh
  #         # Repo.all returns a list
  #   Repo.all(query)
  # end

  # def get_candidate_holds_by_token(token)
  #     when is_binary(token) do
  #   query = from u in User,
  #       join: ut in UserToken, on: u.id == ut.user_id,
  #       join: ch in CandidateHolds, on: u.id == ch.user_id
  #   query = from [u, ut, ch] in query,
  #         where: ut.token == ^token,
  #         select: ch
  #         # Repo.all returns a list
  #   Repo.all(query)
  # end

end
