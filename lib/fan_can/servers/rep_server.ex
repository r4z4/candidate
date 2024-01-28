defmodule FanCan.Servers.RepServer do
  use GenServer
  alias FanCan.Public.StateRepData
  alias FanCan.Core.Utils

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
  def handle_call({:state_rep_data, sym}, state) do
    state_rep_data = get_state_rep_data(:MN)
    new_state = state
    {:reply, state_rep_data, new_state}
  end

  defguard defined_atom(atom) when is_atom(atom) and atom != nil and atom != true and atom != false

  defp get_state_rep_data(state_sym) when defined_atom(state_sym) do
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

  def generate_data do
     # Get 10 lists of random # of tuples
    list_of_lists =
      StreamData.list_of(
        StreamData.tuple({
          StreamData.float(min: 0, max: @max),
          StreamData.float(min: 0, max: @max_2)}
        )
      ) |> Enum.take(10)
    combined_list = Enum.reduce(list_of_lists, fn x, acc -> x ++ acc end)
    combined_list
  end

  def get_color_palette do
    pallete_list = ["FBB4AE", "B3CDE3", "CCEBC5", "C990CE", "E8CB0D", "0DC6E8", "E80D59", "#E85E0D", "B4CE90", "E80D97", "29E80D"]
    Enum.take_random(pallete_list, 3)
  end

  def generate_svg do
    data = generate_data()
    ds = Dataset.new(data, ["x", "y"])
    point_plot = PointPlot.new(ds, colour_palette: get_color_palette())
    plot = Plot.new(300, 200, point_plot)
      |> Plot.plot_options(%{legend_setting: :legend_right})
      |> Plot.titles("Stream Data Plot", "Property Testing & Data Streaming")
      # |> Plot.axis_labels("x", "y")

    Plot.to_svg(plot)
  end

  defp publish(svg) do
    Phoenix.PubSub.broadcast(
      StreamHandler.PubSub,
      @streamer,
      %{topic: @streamer, payload: %{status: :complete, svg: svg}}
    )
  end

  @impl true
  def handle_info(:streamer, state) do
    IO.puts "Handle Streamer"
    # Just random data for now
    svg = generate_svg()
    publish(svg)
    streamer_ref = Process.send_after(self(), :streamer, @call_interval_ms)
    state = Map.put(state, :streamer_ref, streamer_ref)
    {:noreply, state}
  end


end
