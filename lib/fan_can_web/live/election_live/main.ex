defmodule FanCanWeb.ElectionLive.Main do
  use FanCanWeb, :live_view
  require Logger
  alias FanCan.Public
  alias FanCan.Public.Legislator
  alias FanCan.Public.Election
  alias FanCan.Core.{TopicHelpers, Hold, Constants}
  import FanCan.Accounts.Authorize, only: [get_permissions: 1, read?: 2, create?: 2, edit?: 2, delete?: 2]

  @impl true
  def mount(_params, _session, socket) do
    # IO.inspect(socket, label: "Election Socket")
    role = socket.assigns.current_user.role
    {_id, pid} = :ets.lookup(:mailbox_registry, socket.assigns.current_user.id) |> List.first()
    Logger.info("PID = #{inspect pid}", ansi_color: :magenta)
    resp = GenServer.call(pid, {:get, :some_id})
    Logger.info("GenServer Resp = #{inspect resp}", ansi_color: :magenta_background)
    test_message = %{type: :candidate, string: "test_message"}
    FanCanWeb.Endpoint.broadcast!("user_" <> socket.assigns.current_user.id, "new_message", test_message)
    # FIXME: Use CacheEx
    legislators =
      case socket.assigns.use_local_data do
        true -> Public.list_legislators(socket.assigns.current_user.state)
        false -> get_session_people(socket.assigns.legiscan_keys["session_id"], socket.assigns.current_user)
      end
    # IO.inspect(legislators, label: "legislators")
    for {key, value} <- socket.assigns.current_user_holds do
      IO.inspect(key, label: "Type -- Key")
      follow_ids = Enum.map(value, fn hold -> hold.hold_cat_id end)
      # Subscribe to user_holds. E.g. forums that user subscribes to
      TopicHelpers.subscribe_to_holds(key, follow_ids)
    end

    with %{post_ids: post_ids, thread_ids: thread_ids} <- socket.assigns.current_user_published_ids do
      IO.inspect(thread_ids, label: "thread_ids_b")
      for post_id <- post_ids do
        FanCanWeb.Endpoint.subscribe("posts_" <> post_id)
      end
      for thread_id <- thread_ids do
        FanCanWeb.Endpoint.subscribe("threads_" <> thread_id)
      end
    end

    {:ok, socket
          |> stream(:elections, Public.list_elections_and_ballots())
          # Use streams, but for something we display always. Not a flash. Keep flash with assigns below.
          |> stream(:stream_messages, [])
          |> assign(:legislators, legislators)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp get_session_people(session_id, user) do
    GenServer.call(:rep_server, {:get_session_list, session_id, user})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Election")
    |> assign(:election, Public.get_election!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Election")
    |> assign(:election, %Election{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Elections")
    |> assign(:messages, [])
    |> assign(:election, nil)
  end

  @impl true
  def handle_info({FanCanWeb.ElectionLive.FormComponent, {:saved, election}}, socket) do
    {:noreply, stream_insert(socket, :elections, election)}
  end

  @impl true
  def handle_info(%{event: "new_message", payload: new_message}, socket) do
    updated_messages = socket.assigns.messages ++ [new_message]
    IO.inspect(new_message, label: "New Message")

    {:noreply,
     socket
     |> assign(:messages, updated_messages)
     |> put_flash(:info, "PubSub: #{new_message.string}")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    election = Public.get_election!(id)
    {:ok, _} = Public.delete_election(election)

    {:noreply, stream_delete(socket, :elections, election)}
  end
end
