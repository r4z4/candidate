defmodule FanCanWeb.Admin.ScenesLive do
  use FanCanWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>Admin Scenes</.header>
    </div>
    """
  end

  @impl true
  def update(%{forum: forum} = assigns, socket) do

    {:ok,
     socket
     |> assign(assigns)}
  end


  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
