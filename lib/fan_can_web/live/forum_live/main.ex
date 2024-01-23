defmodule FanCanWeb.ForumLive.Main do
  use FanCanWeb, :live_view
  require Logger
  alias FanCan.Site
  alias FanCan.Site.Forum
  alias FanCanWeb.Components.PresenceDisplay

  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
      socket
      |> stream(:forums, Site.list_forums())
      |> assign(:social_count, 0)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Forum")
    |> assign(:forum, Site.get_forum!(id))
  end

  defp apply_action(socket, :main, _params) do
    socket
    |> assign(:page_title, "Forum Main Page")
    |> assign(:forum, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Forum")
    |> assign(:forum, %Forum{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Forums")
    |> assign(:forum, nil)
  end

  defp get_forum_icon(title) do
    case title do
      "The Nebraska Unicameral" -> "building-library"
      "General Forum" -> "chat-bubble-left-ellipsis"
      "User's Forum" -> "users"
      "2024 Election" -> "check-circle"
      "Issues" -> "information-circle"
    end
  end
  
  @impl true 
  def handle_info(
      %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
      %{assigns: %{social_count: count}} = socket
    ) do
    IO.inspect(count, label: "Count")
    social_count = count + map_size(joins) - map_size(leaves)

    {:noreply, assign(socket, :social_count, social_count)}
  end

  @impl true
  def handle_info({FanCanWeb.ForumLive.FormComponent, {:saved, forum}}, socket) do
    {:noreply, stream_insert(socket, :forums, forum)}
  end

  def handle_event("send_message", %{"message" => %{"text" => text, "subject" => subject, "to" => to}}, socket) do
    Logger.info("Params are #{text} and #{subject} and to is #{to}", ansi_color: :blue_background)
    case attrs = %{id: UUIDv7.generate(), to: to, from: socket.assigns.current_user.id, subject: subject, type: :p2p, text: text, read: false} |> FanCan.Site.create_message() do
      {:ok, _} -> 
        info = "Your message has been sent to USERNAME"
        {:noreply,
          socket
          |> put_flash(:info, info)}
      {:error, changeset} -> 
        Logger.info("Send Message Erroer", ansi_color: :yellow)
        error = "Error Sending Message."
        {:noreply,
          socket
          |> put_flash(:error, error)}
    end
  end

  @impl true
  def handle_info(%{event: "new_message", payload: new_message}, socket) do
    updated_messages = socket.assigns[:messages] ++ [new_message]
    case new_message.type do
      :p2p -> Logger.info("In this case we need to refetch all unread messages from DB and display that number", ansi_color: :magenta_background)
      :candidate -> Logger.info("Cndidate New Message", ansi_color: :yellow)
      :post -> Logger.info("Post New Message", ansi_color: :yellow)
      :thread -> Logger.info("Thread New Message", ansi_color: :yellow)
    end

    {:noreply,
     socket
     |> assign(:messages, updated_messages)
     |> put_flash(:info, "PubSub: #{new_message.string}")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    forum = Site.get_forum!(id)
    {:ok, _} = Site.delete_forum(forum)

    {:noreply, stream_delete(socket, :forums, forum)}
  end
end
