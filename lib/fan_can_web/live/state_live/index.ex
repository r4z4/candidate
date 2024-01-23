defmodule FanCanWeb.StateLive.Index do
  use FanCanWeb, :live_view

  alias FanCan.Public
  alias FanCan.Public.State
  alias FanCan.Core.{TopicHelpers, Holds}

  @impl true
  def mount(_params, _session, socket) do
    for follow = %Holds{} <- socket.assigns.current_user_holds do
      IO.inspect(follow, label: "Type")
      # Subscribe to user_holds. E.g. forums that user subscribes to
      case follow.type do
        :candidate -> TopicHelpers.subscribe_to_holds("candidate", follow.follow_ids)
        :user -> TopicHelpers.subscribe_to_holds("user", follow.follow_ids)
        :forum -> TopicHelpers.subscribe_to_holds("forum", follow.follow_ids)
        :election -> TopicHelpers.subscribe_to_holds("election", follow.follow_ids)
      end
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
          |> stream(:states, Public.list_states())
          # Use streams, but for something we display always. Not a flash. Keep flash with assigns below.
          |> stream(:stream_messages, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit State")
    |> assign(:state, Public.get_state!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New State")
    |> assign(:state, %State{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing States")
    |> assign(:messages, [])
    |> assign(:state, nil)
  end

  @impl true
  def handle_info({FanCanWeb.StateLive.FormComponent, {:saved, state}}, socket) do
    {:noreply, stream_insert(socket, :states, state)}
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
    state = Public.get_state!(id)
    {:ok, _} = Public.delete_state(state)

    {:noreply, stream_delete(socket, :states, state)}
  end
end
