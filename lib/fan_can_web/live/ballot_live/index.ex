defmodule FanCanWeb.BallotLive.Index do
  use FanCanWeb, :live_view

  alias FanCan.Public.Election
  alias FanCan.Public.Election.Ballot
  alias FanCan.Core.{TopicHelpers, Hold, HoldMap}

  @impl true
  def mount(_params, _session, socket) do
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
          |> stream(:ballots, Election.list_ballots())
          # Use streams, but for something we display always. Not a flash. Keep flash with assigns below.
          |> stream(:stream_messages, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Ballot")
    |> assign(:ballot, Election.get_ballot!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Ballot")
    |> assign(:ballot, %Ballot{})
  end

  defp apply_action(socket, :template, _params) do
    socket
    |> assign(:page_title, "Ballot Template")
    |> assign(:messages, [])
    |> assign(:ballot, nil)
  end

  @impl true
  def handle_info({FanCanWeb.BallotLive.FormComponent, {:saved, ballot}}, socket) do
    {:noreply, stream_insert(socket, :ballots, ballot)}
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
    ballot = Election.get_ballot!(id)
    {:ok, _} = Election.delete_ballot(ballot)

    {:noreply, stream_delete(socket, :ballots, ballot)}
  end
end
