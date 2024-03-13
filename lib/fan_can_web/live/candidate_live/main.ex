defmodule FanCanWeb.CandidateLive.Main do
  use FanCanWeb, :live_view

  alias FanCan.Public
  alias FanCan.Public.Candidate
  alias FanCan.Accounts
  alias FanCan.Core.{TopicHelpers, Hold}
  alias FanCanWeb.Components.CandidateSnapshot

  @impl true
  def mount(_params, _session, socket) do
    dbg(socket.assigns.current_user_holds)
    # {email, username} = Accounts.get_user_data_by_token(session["user_token"])
    # %{entries: entries, page_number: page_number, page_size: page_size, total_entries: total_entries, total_pages: total_pages}
    FanCanWeb.Endpoint.subscribe("topic")
    mayor = Public.get_mayor(socket.assigns.current_user.city, socket.assigns.current_user.state)
    result = if connected?(socket), do: Public.paginate_candidates(), else: %Scrivener.Page{}

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

    loc_info = get_voter_info(socket.assigns.current_user)
    nominations = api_query(socket.assigns.current_user.state)

    {:ok,
     socket
     |> stream(:candidates, result.entries)
     |> stream(:stream_messages, [])
     |> assign(:loc_info, loc_info)
     |> assign(:nominations, nominations)
     |> assign(:page_number, result.page_number || 0)
     |> assign(:page_size, result.page_size || 0)
     |> assign(:total_entries, result.total_entries || 0)
     |> assign(:mayor, mayor)
     |> assign(:total_pages, result.total_pages || 0)}
  end

  defp get_voter_info(user) do
    # {:ok, value} = Cachex.get(:main_cache, "floor_task_result_#{user_id}")
    # IO.inspect(value, label: "Val")
    IO.inspect(user, label: "User in Voter Info")
    {:ok, resp} =
      Finch.build(:get, "https://civicinfo.googleapis.com/civicinfo/v2/voterinfo?address=12%20M%20#{user.city}%2C%20#{user.state}&electionId=2000&key=#{System.fetch_env!("GCLOUD_API_KEY")}")
      |> Finch.request(FanCan.Finch)

    dbg(resp)
    {:ok, body} = Jason.decode(resp.body)

    dbg(body)

    filtered =
      Enum.filter(body["contests"], fn(contest) ->
        Map.has_key?(contest, "candidates")
      end)

    dbg(filtered)

    # IO.inspect(body, label: "Body")
    # IO.inspect(filtered, label: "Filtered")
    filtered
  end

  defp api_query(state) do
    IO.puts("Api Query firing")
    # state_str = Utils.get_state_str(state)
    # IO.inspect(state_str, label: "State")
    {:ok, resp} =
      Finch.build(:get, "https://api.propublica.org/congress/v1/117/nominees/state/NE.json", [{"X-API-Key", System.fetch_env!("PROPUB_KEY")}])
      |> Finch.request(FanCan.Finch)

    {:ok, body} = Jason.decode(resp.body)

    # IO.inspect(body["offices"], label: "Offices")
    IO.inspect(body, label: "nominees")
    # Return it as a list of map-items
    body["results"]
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :main, _params) do
    socket
    |> assign(:page_title, "Forum Main Page")
    |> assign(:candidates, nil)
  end

  defp page_title(:show), do: "Show Candidate"
  defp page_title(:edit), do: "Edit Candidate"
end
