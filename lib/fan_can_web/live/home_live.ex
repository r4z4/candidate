defmodule FanCanWeb.HomeLive do
  use FanCanWeb, :live_view
  require Logger

  alias FanCan.Accounts
  alias FanCan.Core.TopicHelpers
  alias FanCan.Public.Election
  alias FanCanWeb.Components.StateSnapshot
  alias FanCanWeb.Components.PresenceDisplay
  alias FanCan.Core.Utils
  alias FanCan.Site
  alias FanCanWeb.Components.MailboxCard
  alias FanCan.Presence

#   def mount(%{"token" => token}, _session, socket) do
#     socket =
#       case Accounts.update_user_email(socket.assigns.current_user, token) do
#         :ok ->
#           put_flash(socket, :info, "Email changed successfully.")

#         :error ->
#           put_flash(socket, :error, "Email change link is invalid or it has expired.")
#       end

#     {:ok, push_navigate(socket, to: ~p"/users/settings")}
#   end

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    # Send to ETS table vs storing in socket
    # g_candidates = api_query(socket.assigns.current_user.state)
    {atom, value} = Cachex.get(:main_cache, "g_candidates_result_#{user_id}")
    g_candidates_result =
      case {atom, value} do
        {:ok, value} ->
          if value do
            value
          else
            g_task =
              Task.Supervisor.async(FanCan.TaskSupervisor, fn ->
                IO.puts("Hey from a task")
                api_query(socket.assigns.current_user.state)
              end)
            g_task_result = Task.await(g_task, 10000)
            Cachex.put!(:main_cache, "g_candidates_result_#{user_id}", g_task_result)
            g_task_result
          end
        {:error, _value} ->
          # Send back blank object for now
          %{
            "chamber" => "Error",
            "congress" => "9999",
            "date" => "1900-01-01",
            "floor_actions" => [],
            "num_results" => 0,
            "offset" => 0
          }
        _ ->
          %{error: "Unexpected Error"}
      end

    Logger.info("Home Socket = #{inspect socket}", ansi_color: :magenta)
    # IO.inspect(self(), label: "Self")
    # IO.inspect(socket, label: "Home Socket")
    for hold_cat <- socket.assigns.current_user_holds do
      IO.inspect(hold_cat, label: "hold_cat")
      # Subscribe to user_holds. E.g. forums that user subscribes to
      sub_and_add(hold_cat, socket)
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
    # # FanCanWeb.Endpoint.subscribe("topic")
    # IO.inspect(socket, label: "Socket")
    # pid = spawn(FanCanWeb.SubscriptionServer, :start, [])
    # IO.inspect(pid, label: "SubscriptionSupervisor PIN =>=>=>=>")
    # send pid, {:subscribe_user_holds, socket.assigns.current_user_holds}
    # send pid, {:subscribe_user_published, socket.assigns.current_user_published_ids}
    # # ThinWrapper.put("game_data", game_data)
    # # game_data = ThinWrapper.get("game_data")

    {atom, value} = Cachex.get(:main_cache, "floor_task_result_#{user_id}")
    floor_result =
      case {atom, value} do
        {:ok, value} ->
          if value do
            value
          else
            floor_task =
              Task.Supervisor.async(FanCan.TaskSupervisor, fn ->
                IO.puts("Hey from a task")
                _floor_actions = floor_query("house")
              end)
            floor_result = Task.await(floor_task, 10000)
            Cachex.put!(:main_cache, "floor_task_result_#{user_id}", floor_result)
            floor_result
          end
        {:error, _value} ->
          # Send back blank object for now
          %{
            "chamber" => "Error",
            "congress" => "9999",
            "date" => "1900-01-01",
            "floor_actions" => [],
            "num_results" => 0,
            "offset" => 0
          }
        _ ->
          %{error: "Unexpected Error"}
      end

    {:ok,
     socket
     |> assign(:messages, [])
     |> assign(:g_candidates, g_candidates_result)
     # |> assign(:floor_actions, Task.await(floor_task, 10000))
     |> assign(:floor_actions, floor_result)
     |> assign(:message_count, Kernel.length(FanCan.Site.list_user_messages(user_id)))
     |> assign(:lobby_count, 0)
     |> assign(:forum_count, 0)}
  end
  # this is the order returned from the query in accounts.ex
  defp sub_and_add(hold_cat, _socket) do
    TopicHelpers.subscribe_to_holds(Kernel.elem(hold_cat, 0), Kernel.elem(hold_cat, 1) |> Enum.map(fn h -> h.id end))
    # :forum_holds -> TopicHelpers.subscribe_to_holds("forum", Kernel.elem(hold_cat, 1) |> Enum.map(fn h -> h.id end))
  end

  defp get_races(holds) do
    # IO.inspect(holds, label: "HOLDS")
    holds.race_holds
    |> Enum.filter(fn x -> x.type == :bookmark end)
    |> Enum.map(fn x -> x.hold_cat_id end)
    |> Election.get_races()
  end

  defp get_elections(holds) do
    holds.election_holds
    |> Enum.map(fn x -> x.hold_cat_id end)
    |> Election.get_elections()
  end

  defp get_favorites(holds) do
    # IO.inspect(holds, label: "holds")
    _all_holds = holds.candidate_holds ++ holds.user_holds ++ holds.election_holds ++ holds.race_holds ++ holds.post_holds ++ holds.thread_holds
    |> Enum.filter(fn x -> x.type == :favorite end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
    <.live_component module={MailboxCard} message_count={@message_count} user_id={@current_user.id} id="mailbox_card" />
    <.live_component module={PresenceDisplay} lobby_count={@lobby_count} user_follow_holds={@current_user_holds.user_holds} user_id={@current_user.id} username={@current_user.username} room="Lobby" id="presence_display" />
      <.header class="text-center">
        Hello <%= assigns.current_user.username %> || Welcome to Fantasy Candidate
        <:subtitle>Not Really Sure What We're Doing Here Yet</:subtitle>
      </.header>

      <div class="grid justify-center mx-auto text-center md:grid-cols-3 lg:grid-cols-3 gap-10 lg:gap-10 my-10 text-white">

        <div>
          <.link
            href={~p"/candidates/main"}
            class="group -mx-2 -my-0.5 inline-flex items-center gap-3 rounded-lg px-2 py-0.5 hover:bg-zinc-50 hover:text-zinc-900"
          >
            <Heroicons.LiveView.icon name="users" type="outline" class="h-10 w-10 text-emerald" />
            Candidates
          </.link>
        </div>

        <div>
          <.link
            href={~p"/elections/main"}
            class="group -mx-2 -my-0.5 inline-flex items-center gap-3 rounded-lg px-2 py-0.5 hover:bg-zinc-50 hover:text-zinc-900"
          >
            <Heroicons.LiveView.icon name="check-badge" type="outline" class="h-10 w-10 text-red" />
            Elections
          </.link>
        </div>

        <div>
          <.link
            href={~p"/forums/main"}
            class="group -mx-2 -my-0.5 inline-flex items-center gap-3 rounded-lg px-2 py-0.5 hover:bg-zinc-50 hover:text-zinc-900"
          >
            <Heroicons.LiveView.icon name="chat-bubble-left-right" type="outline" class="h-10 w-10 text-white" />
            Forums
          </.link>
        </div>

      </div>

      <div class="relative flex py-5 items-center">
        <div class="flex-grow border-t border-gray-400"></div>
        <span class="flex-shrink mx-4 text-gray-400">Content</span>
        <div class="flex-grow border-t border-gray-400"></div>
      </div>

        <div class="grid justify-center md:grid-cols-3 lg:grid-cols-3 gap-10 lg:gap-10">

          <div class="text-center m-auto border-solid border-2 border-white rounded-lg p-2">
            <div class="text-white inline"><Heroicons.LiveView.icon name="eye" type="outline" class="inline h-5 w-5 text-white m-2" />
              Races You Are Watching
            </div>
            <div class="text-white">
              <div :for={race <- get_races(@current_user_holds)} class="">
                <.link href={~p"/races/#{race.id}"}><p><%= race.district %> - <%= race.seat %></p></.link>
              </div>
            </div>
          </div>

          <div class="text-center m-auto border-solid border-2 border-white rounded-lg p-2">
            <div class="text-white inline"><Heroicons.LiveView.icon name="star" type="outline" class="inline h-5 w-5 text-white m-2" />
              Your List of Favorites
            </div>
            <div class="text-white">
              <div :for={fav <- get_favorites(@current_user_holds)} class="">
                <.link href={~p"/"}><p><%= fav.hold_cat %></p></.link>
              </div>
            </div>
          </div>

          <div class="text-center m-auto border-solid border-2 border-white rounded-lg p-2">
            <div class="text-white inline"><Heroicons.LiveView.icon name="star" type="outline" class="inline h-5 w-5 text-white m-2" />
              Your Shared Items
            </div>
            <div class="text-white">
              <div :for={election <- get_elections(@current_user_holds)} class="">
                <.link href={~p"/elections/#{election.id}"}><p><%= election.desc %></p></.link>
              </div>
            </div>
          </div>

        </div>

        <StateSnapshot.display state={@current_user.state} g_candidates={@g_candidates}/>
    </div>
    """
  end

  @impl true
  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("send_message", %{"message" => %{"text" => text, "subject" => subject, "to" => to, "patch" => patch}}, socket) do
    Logger.info("Params are #{text} and #{subject} and to is #{to}", ansi_color: :blue_background)
    user_id = socket.assigns.current_user.id
    # 10 per minute
    case Hammer.check_rate("send_message:#{user_id}", 60_000, 10) do
      {:allow, _count} ->
        case attrs = %{id: UUIDv7.generate(), to: to, from: socket.assigns.current_user.id, subject: subject, type: :p2p, text: text} |> FanCan.Site.create_message() do
          {:ok, _} ->
            notif = "Your message has been sent!"
            recv = %{type: :p2p, string: "New Message Received"}
            FanCanWeb.Endpoint.broadcast!("user_" <> to, "new_message", recv)
            {:noreply,
              socket
              |> put_flash(:info, notif)
              |> push_navigate(to: patch)}
          {:error, changeset} ->
            Logger.error("Send Message Error: #{changeset.errors}", ansi_color: :yellow)
            notif = "Error Sending Message."
            {:noreply,
              socket
              |> put_flash(:error, notif)}
        end
      {:deny, _limit} ->
        notif = "You are sending too many messages."
        {:noreply,
          socket
          |> put_flash(:error, notif)}
    end
  end

  @impl true
  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  @impl true
  def handle_event("mark_read", %{"id" => id}, socket) do
    IO.puts("Mark Read")
    message = Site.get_message!(id)
    if !message.read do
      Site.update_message(message, %{read: true})
    end
    {:noreply, socket}
  end

  # Why am I not able to use phx-value-read in this case?
  @impl true
  def handle_event("mark_read", %{"id" => id, "read" => read}, socket) do
    IO.puts("Mark Read w/ Read")
    if !read do
      message = Site.get_message!(id)
      Site.update_message(message, %{read: true})
    end
    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_read", %{"id" => _id}, socket) do
    IO.puts("Toggle Read")
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "new_message", payload: new_message}, socket) do
    case new_message.type do
      :p2p -> Logger.info("In this case we need to refetch all unread messages from DB and display that number", ansi_color: :magenta_background)
      :candidate -> Logger.info("Candidate New Message", ansi_color: :yellow)
      :post -> Logger.info("Post New Message", ansi_color: :yellow)
      :thread -> Logger.info("Thread New Message", ansi_color: :yellow)
    end

    {:noreply,
     socket
     |> assign(:messages, FanCan.Site.list_user_messages(socket.assigns.current_user.id))
     |> put_flash(:info, "PubSub: #{new_message.string}")}
  end

  @impl true
  def handle_info(
      %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
      %{assigns: %{lobby_count: _lobby_count, forum_count: _forum_count}} = socket
    ) do
    IO.inspect(joins, label: "Joins")
    IO.inspect(leaves, label: "Leaves")
    lobby_count = Presence.list("Lobby") |> map_size
    forum_count = Presence.list("Forums") |> map_size
    # social_count = count + map_size(joins) - map_size(leaves)

    {:noreply,
      socket
      |> assign(:lobby_count, lobby_count)
      |> assign(:forum_count, forum_count)}
  end

  @impl true
  def handle_info(
      %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
      %{assigns: %{social_count: count}} = socket
    ) when leaves == %{} do

    {:noreply, socket}
  end



  # def get_loc_info(ip) do
  #   {:ok, resp} =
  #   #   Finch.build(:get, "https://ip.city/api.php?ip=#{ip}&key=#{System.fetch_env!("IP_CITY_API_KEY")}")
  #   #   |> Finch.request(FanCan.Finch)
  #       Finch.build(:get, "https://ipinfo.io/#{ip}?token=#{System.fetch_env!("IP_INFO_TOKEN")}")
  #       |> Finch.request(FanCan.Finch)
  #   IO.inspect(resp, label: "Loc Info Resp")
  #   resp
  # end

  def api_query(state) do
    state_str = Utils.get_state_str(state)
    {:ok, resp} =
      Finch.build(:get, "https://civicinfo.googleapis.com/civicinfo/v2/representatives?address=#{state_str}&key=#{System.fetch_env!("GCLOUD_API_KEY")}")
      |> Finch.request(FanCan.Finch)

    {:ok, body} = Jason.decode(resp.body)

    # IO.inspect(body["offices"], label: "Offices")

    %{"offices" => body["offices"], "officials" => body["officials"]}
  end

      @doc """
      "results" => [
        %{
          "chamber" => "House",
          "congress" => "118",
          "date" => "2023-07-30",
          "floor_actions" => [],
          "num_results" => 0,
          "offset" => 0
        }
      ],
    """

  defp floor_query(chamber \\ "house") do
    date = Date.utc_today()
    # state_str = Utils.get_state_str(state)
    # IO.inspect(state_str, label: "State")
    {:ok, resp} =
      Finch.build(:get, "https://api.propublica.org/congress/v1/#{chamber}/floor_updates/#{date.year}/#{date.month}/#{date.day}.json", [{"X-API-Key", System.fetch_env!("PROPUB_KEY")}])
      |> Finch.request(FanCan.Finch)

    {:ok, body} = Jason.decode(resp.body)

    body["results"]
  end

  # def handle_event("new_message", params, socket) do
  #   {:noreply, socket}
  # end
end
