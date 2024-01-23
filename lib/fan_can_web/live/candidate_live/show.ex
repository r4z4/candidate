defmodule FanCanWeb.CandidateLive.Show do
  use FanCanWeb, :live_view

  alias FanCan.Public
  alias FanCan.Core
  alias FanCan.Core.Utils
  alias FanCan.Core.MapHelpers

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    FanCanWeb.Endpoint.subscribe("topic")
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    candidate = Public.get_candidate!(id)
    image_path =
    if candidate.attachments && List.first(candidate.attachments) do
      image = Core.get_attachment!(List.first(candidate.attachments))
      image.path
    else
      Utils.no_image
    end

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:candidate, candidate)
     |> assign(:image_path, image_path)}
  end
  @impl true
  def handle_info(%{event: "new_message", payload: new_message}, socket) do
    updated_messages = socket.assigns[:messages] ++ [new_message]
    IO.inspect(new_message, label: "New Message")

    {:noreply, 
     socket 
     |> assign(:messages, updated_messages)
     |> put_flash(:info, "PubSub: #{new_message}")}
  end

  defp page_title(:show), do: "Show Candidate"
  defp page_title(:edit), do: "Edit Candidate"
end
