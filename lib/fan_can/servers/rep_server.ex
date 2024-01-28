defmodule FanCan.Servers.RepServer do
  use GenServer
  alias FanCan.Public.StateRepData
  alias FanCan.Core.Utils
  alias FanCan.Public

  @time_interval_ms 2000
  @call_interval_ms 3000

  def start_link([name, state]) do
    IO.inspect(state, label: "start_link")
    GenServer.start_link(__MODULE__, state, name: name)
  end

  # handle_cast handling the call from outside. Calls from the process (all subsequent) handled by handle_info
  @impl true
  def handle_cast({:start_resource_poll, sym}, state) do
    Process.send_after(self(), sym, @time_interval_ms)
    IO.puts(sym)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:stop_resource_poll, sym}, state) do
    case sym do
      :streamer -> Process.cancel_timer(state.streamer_ref)
      _ -> Process.cancel_timer(state.streamer_ref)
    end
    # Process.cancel_timer(self(), sym, @time_interval_ms)
    IO.puts(sym)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:fetch_resource, sym}, state) do
    Process.send_after(self(), sym, @time_interval_ms)
    IO.puts(sym)
    {:noreply, state}
  end

  @impl true
  def handle_call({:state_rep_data, sym}, _from, state) do
    state_rep_data = get_state_rep_data(:MN)
    new_state = state
    {:reply, state_rep_data, new_state}
  end

  @impl true
  def handle_call({:get_session_list, session_id, user_state}, _from, state) do
    list = get_session_people(session_id, user_state)
    new_state = state
    {:reply, list, new_state}
  end

  defguard defined_atom(atom) when is_atom(atom) and atom != nil and atom != true and atom != false

  def get_state_rep_data(state_sym) when defined_atom(state_sym) do
    # Hit all the APIs
    %StateRepData{state: state_sym, reps: []}
  end

  @impl true
  def init(state) do
    # _table = :ets.new(:user_scores, [:ordered_set, :protected, :named_table])
    IO.inspect state, label: "init"
    refs_map = %{streamer_ref: nil}
    {:ok, refs_map}
  end

  @impl true
  def handle_info(:streamer, state) do
    IO.puts "Handle Streamer"
    # Just random data for now
    streamer_ref = Process.send_after(self(), :streamer, @call_interval_ms)
    state = Map.put(state, :streamer_ref, streamer_ref)
    {:noreply, state}
  end

  ### API Calls ###
  ### LegiScan, ProPublica, GoogleCivicInfo, OpenSecrets ### FIXME: Add VoteSmart

  def google_api_query(state) do
    state_str = Utils.get_state_str(state)
    {:ok, resp} =
      Finch.build(:get, "https://civicinfo.googleapis.com/civicinfo/v2/representatives?address=#{state_str}&key=#{System.fetch_env!("GCLOUD_API_KEY")}")
      |> Finch.request(FanCan.Finch)

    {:ok, body} = Jason.decode(resp.body)

    # IO.inspect(body["offices"], label: "Offices")

    %{"offices" => body["offices"], "officials" => body["officials"]}
  end

  defp floor_query(chamber \\ "house") do
    date = Date.utc_today()
    # state_str = Utils.get_state_str(state)
    # IO.inspect(state_str, label: "State")
    {:ok, resp} =
      Finch.build(:get, "https://api.propublica.org/congress/v1/#{chamber}/floor_updates/#{date.year}/#{date.month}/#{date.day}.json", [{"X-API-Key", System.fetch_env!("PROPUB_KEY")}])
      |> Finch.request(FanCan.Finch)

    {:ok, body} = Jason.decode(resp.body)

    body["results"]
  end

  defp get_session_people(session_id, user) do
    IO.puts("get_session_people")
    election_id = Election.get_election_id(user.state, Constants.current_election)
    # state_str = Utils.get_state_str(state)
    # IO.inspect(state_str, label: "State")
    {:ok, resp} =
      Finch.build(:get, "https://api.legiscan.com/?key=#{System.fetch_env!("LEGISCAN_KEY")}&op=getSessionPeople&id=#{session_id}")
      |> Finch.request(FanCan.Finch)

    {:ok, body} = Jason.decode(resp.body)

    # IO.inspect(body["offices"], label: "Offices")
    # IO.inspect(body, label: "session people")
    list = body["sessionpeople"]["people"]

    # This is the local data thing
    # Insert into DB as JSONB now too
    for item <- list do
      attrs = %{api_map: item}
      # Save into cache
      case Public.create_legislator_json(attrs) do
        {:ok, _leg} -> :ok
        {:error, _changeset} -> IO.puts("Nope")
      end
    end

    struct_list = to_structs(list)
    # Return it as a list of map-items
    case Public.create_legislators(struct_list) do
      {id, legislators} ->
        legislators = legislators
        create_ballot(election_id, user.id)
        create_ballot_races(legislators, election_id)
        legislators

      {:error, resp} -> IO.inspect(resp, label: "RESP")
        {:error, "Error in Persist People"}
    end

  end

  defp to_structs(list) do
    # IO.inspect(list, label: "LIST")
    for item <- list do
      leg_with_atom_keys = for {key, val} <- item, into: %{} do
        {String.to_existing_atom(key), val}
      end
      # leg_struct = struct(Legislator, leg_with_atom_keys)
      leg_with_atom_keys
    end
  end

  defp create_ballot(election_id, user_id) do
    attrs = %{election_id: election_id, user_id: user_id, submitted: false}
    case Election.create_ballot(attrs) do
      {:ok, ballot} ->
        IO.puts("ballot")
      {:error, resp} ->
        IO.inspect(resp, label: "RESP")
        {:error, "Error in ballot"}
    end
  end

  defp create_ballot_races(legislators, election_id) do
    # IO.inspect(List.first(legislators), label: "LIST first leg")
    race_list = Enum.map(legislators, fn leg -> %{election_id: election_id, candidates: [leg.id], seat: String.to_existing_atom(leg.role), district: leg.district, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()} end)
    # IO.inspect(race_list, label: "race_list")
    case Public.create_leg_ballot_races(race_list) do
      {:ok, id} -> IO.inspect(id, label: "ID of Created Insert all")
      {:error, resp} -> IO.inspect(resp, label: "RESP")
        {:error, "Error in Persist People"}
    end
  end


end
