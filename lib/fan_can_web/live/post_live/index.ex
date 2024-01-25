defmodule FanCanWeb.PostLive.Index do
  use FanCanWeb, :live_view

  alias FanCan.Site.Forum
  alias FanCan.Site.Forum.Post
  alias FanCan.Core.{TopicHelpers, Hold}
  import FanCan.Accounts.Authorize

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
          |> stream(:posts, Forum.list_posts())
          # Use streams, but for something we display always. Not a flash. Keep flash with assigns below.
          |> stream(:stream_messages, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Forum.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:messages, [])
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({FanCanWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :posts, post)}
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
    post = Forum.get_post!(id)
    {:ok, _} = Forum.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end
end
