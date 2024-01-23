defmodule FanCanWeb.RaceLive.Inspect do
  use FanCanWeb, :live_view

  alias FanCan.Public.Election

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    race = Election.get_race!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:race, race)
     |> assign(:image_path, "/images/ne_districts/District#{race.district}.png")}
  end

  defp page_title(:inspect), do: "Inspect the Race. Do Your Homework."
end