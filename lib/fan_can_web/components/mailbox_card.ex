defmodule FanCanWeb.Components.MailboxCard do
  use Phoenix.LiveComponent
  alias FanCanWeb.CoreComponents

  @impl true
  def mount(params, _session, socket) do
    IO.inspect(params, label: "Params")

    {:ok, socket
      |> assign(:count, params.count)
      |> assign(:user_id, params.user_id)}
  end

  def update(assigns, socket) do
    IO.inspect(assigns, label: "Assings")
    IO.inspect(socket, label: "Socket")
    socket = assign(socket, assigns)
    # before subscribing, get current_player_count
    # topic = "Lobby"


    {:ok, socket}
  end
  @impl true
  def render(assigns) do
    ~H"""
      <section class="text-white body-font">
        <button class="mb-2 flex rounded bg-primary px-6 pb-2 pt-2.5 text-xs font-medium uppercase leading-normal text-white shadow-[0_4px_9px_-4px_#3b71ca] transition duration-150 ease-in-out hover:bg-primary-600 hover:shadow-[0_8px_9px_-4px_rgba(59,113,202,0.3),0_4px_18px_0_rgba(59,113,202,0.2)] focus:bg-primary-600 focus:shadow-[0_8px_9px_-4px_rgba(59,113,202,0.3),0_4px_18px_0_rgba(59,113,202,0.2)] focus:outline-none focus:ring-0 active:bg-primary-700 active:shadow-[0_8px_9px_-4px_rgba(59,113,202,0.3),0_4px_18px_0_rgba(59,113,202,0.2)]" phx-click={FanCanWeb.CoreComponents.show_modal("user-modal")}><span aria-hidden="true">📧</span> Messages
          <span class="ml-2 inline-block whitespace-nowrap rounded-[0.27rem] bg-danger-100 px-[0.65em] pb-[0.25em] pt-[0.35em] text-center align-baseline text-[0.75em] font-bold leading-none text-danger-700"><%= @message_count %></span>
        </button>
      </section>
    """
  end
end
