defmodule FanCanWeb.ElectionLive.Show do
  use FanCanWeb, :live_view

  alias FanCan.Public

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:election, Public.get_election!(id))}
  end

  defp page_title(:show), do: "Show Election"
  defp page_title(:edit), do: "Edit Election"
end
