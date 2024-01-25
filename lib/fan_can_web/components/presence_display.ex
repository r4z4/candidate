defmodule FanCanWeb.Components.PresenceDisplay do
  use Phoenix.LiveComponent
  alias FanCan.Presence
  alias FanCan.Accounts
  alias FanCanWeb.Components.SendMessage
  alias FanCanWeb.CoreComponents
  #{u.username, u.email, u.confirmed_at, us.easy_games_played, us.easy_games_finished, us.med_games_played, us.med_games_finished, us.hard_games_played, us.hard_games_finished,
  # us.easy_poss_pts, us.easy_earned_pts, us.med_poss_pts, us.med_earned_pts, us.hard_poss_pts, us.hard_earned_pts}

  def mount(params, _session, socket) do
    Logger.info("Presence Mount", ansi_color: [:magenta, :yellow_background])
    # # before subscribing, get current_player_count
    # topic = "home_page"
    # initial_count = Presence.list(topic) |> map_size

    # # Subscribe to the topic
    # FanCanWeb.Endpoint.subscribe(topic)

    # # Track changes to the topic
    # Presence.track(
    #   self(),
    #   topic,
    #   socket.id,
    #   %{}
    # )
    # Assigning to parent LV socket. Use thin_wrapper
    {:ok,
      socket
      |> assign(:room, params.room)
      |> assign(:form, to_form(%{}, as: "message"))}
  end

  defp users_from_metas(metas) do
    Enum.map(metas, &get_in(&1, [:username]))
    |> Enum.uniq()
  end

  def get_users(joins) do
    for x <- Map.keys(joins) do
      joins
        |> Map.get(x)
        |> Map.get(:metas)
        |> List.first()
    end
  end

  def update(assigns, socket) do
    socket = assign(socket, assigns)
    # before subscribing, get current_player_count
    # topic = "Lobby"
    initial_count = Presence.list(assigns.room) |> map_size
    users = Presence.list(assigns.room) |> get_users()
    # Subscribe to the topic
    FanCanWeb.Endpoint.subscribe(assigns.room)

    # Track changes to the topic
    Presence.track(
      self(),
      assigns.room,
      socket.id,
      %{
        username: assigns.username,
        user_id: assigns.user_id,
        joined_at: :os.system_time(:seconds)
      }
    )

    {:ok,
      socket
      |> assign(:users, users)
      |> assign(:social_count, initial_count)
      |> assign(:form, to_form(%{}, as: "message"))}
  end

  slot :inner_block, required: true do
    "Innr Block"
  end

  def render(assigns) do
    ~H"""
    <section class="relative top-0 left-0">
      <div class="flex items-center justify-center my-4">
          <!-- Card -->
            <%= for user <- assigns.users do %>
                <div class="flex items-center justify-between mx-1 p-2 rounded-lg bg-white shadow-indigo-50 shadow-md">
                  <div class="flex items-center justify-center">
                    <div :if={Enum.member?(@user_follow_holds, user.user_id)}>
                      <button phx-click="toggle_follow" value={ user.user_id } id="follow_btn">✅</button>
                    </div>
                      <icon :if={user.user_id == assigns.user_id}><Heroicons.LiveView.icon name="user-circle" class="h-4 w-4 text-green-700" /></icon><%= user.username %>
                  </div>
                  <div>
                    <icon :if={Enum.member?(@user_follow_holds, user.user_id)} phx-click={CoreComponents.show_modal("send_message_" <> user.user_id)} value={ user.user_id }>🗉</icon>
                    <icon class="hover:cursor-pointer" phx-click={CoreComponents.show_modal("send_message_" <> user.user_id)} value={ user.user_id }><Heroicons.LiveView.icon name="envelope" class="ml-2 h-3 w-3" /></icon>
                  </div>
              </div>
              <CoreComponents.modal id={"send_message_" <> user.user_id}>
                <h2 class="text-center text-white">Send Message</h2>
                <CoreComponents.simple_form for={@form} id="send_message_form" phx-submit="send_message">

                  <p class="text-white">To: <%= user.username %></p>
                  <CoreComponents.input field={@form[:to]} type="hidden" value={ user.user_id } readonly />
                  <CoreComponents.input field={@form[:patch]} type="hidden" value={ "/home" } readonly />

                  <CoreComponents.input field={@form[:subject]} type="text" placeholder="Subject" required />
                  <CoreComponents.input field={@form[:text]} type="textarea" placeholder="Message" required />
                  <:actions>
                    <CoreComponents.button phx-disable-with="Sending..." class="w-full">
                      Send Message
                    </CoreComponents.button>
                  </:actions>>
                </CoreComponents.simple_form>
              </CoreComponents.modal>
            <% end %>
          <!-- End Card -->
        </div>
    </section>
    """
  end

  def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
        %{assigns: %{user_id_list: id_list, users: users}} = socket
      ) do
      IO.inspect(joins, label: "Joins")
    user_id_list = [Map.keys(joins) | id_list] |> List.delete(Map.keys(leaves))
    users = get_users(joins) ++ users |> List.delete(get_users(leaves))
    IO.inspect(users, label: "Users List")
    IO.inspect(Kernel.length(users), label: "Username List Length")

    {:noreply, socket
      |> assign(user_id_list: user_id_list)
      |> assign(users: users)}
  end

  def handle_event("social", _value, socket) do
    {:noreply,
      socket
      |> push_redirect(to: "/forums/main")}
    # Get back to using changesets
    # {:noreply, assign(socket |> assign(changeset: changeset))}
  end
end
