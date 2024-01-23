defmodule FanCanWeb.UserAuth do
  use FanCanWeb, :verified_routes
  require Logger
  import Plug.Conn
  import Phoenix.Controller

  alias FanCan.Accounts
  alias FanCan.Core.Utils
  alias FanCan.Public

  # Make the remember me cookie valid for 60 days.
  # If you want bump or reduce this value, also change
  # the token expiry itself in UserToken.
  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_fan_can_web_user_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  @doc """
  Logs the user in.

  It renews the session ID and clears the whole session
  to avoid fixation attacks. See the renew_session
  function to customize this behaviour.

  It also sets a `:live_socket_id` key in the session,
  so LiveView sessions are identified and automatically
  disconnected on log out. The line can be safely removed
  if you are not using LiveView.
  """
  def log_in_user(conn, user, params \\ %{}) do
    token = Accounts.generate_user_session_token(user)
    user_return_to = get_session(conn, :user_return_to)

    ip_str = conn.remote_ip |> :inet_parse.ntoa |> to_string()


    conn
    |> renew_session()
    |> put_token_in_session(token)
    |> put_session(:remote_ip, ip_str)
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: user_return_to || signed_in_path(conn))
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing, for example:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Logs the user out.

  It clears all session data for safety. See renew_session.
  """
  def log_out_user(conn) do
    user_token = get_session(conn, :user_token)
    user_token && Accounts.delete_user_session_token(user_token)

    if live_socket_id = get_session(conn, :live_socket_id) do
      FanCanWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: ~p"/")
  end

  @doc """
  Authenticates the user by looking into the session
  and remember me token.
  """
  def fetch_current_user(conn, _opts) do
    {user_token, conn} = ensure_user_token(conn)
    user = user_token && Accounts.get_user_by_session_token(user_token)
    assign(conn, :current_user, user)
  end

  defp ensure_user_token(conn) do
    if token = get_session(conn, :user_token) do
      {token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if token = conn.cookies[@remember_me_cookie] do
        {token, put_token_in_session(conn, token)}
      else
        {nil, conn}
      end
    end
  end

  @doc """
  Handles mounting and authenticating the current_user in LiveViews.

  ## `on_mount` arguments

    * `:mount_current_user` - Assigns current_user
      to socket assigns based on user_token, or nil if
      there's no user_token or no matching user.

    * `:ensure_authenticated` - Authenticates the user from the session,
      and assigns the current_user to socket assigns based
      on user_token.
      Redirects to login page if there's no logged user.

    * `:redirect_if_user_is_authenticated` - Authenticates the user from the session.
      Redirects to signed_in_path if there's a logged user.

  ## Examples

  Use the `on_mount` lifecycle macro in LiveViews to mount or authenticate
  the current_user:

      defmodule FanCanWeb.PageLive do
        use FanCanWeb, :live_view

        on_mount {FanCanWeb.UserAuth, :mount_current_user}
        ...
      end

  Or use the `live_session` of your router to invoke the on_mount callback:

      live_session :authenticated, on_mount: [{FanCanWeb.UserAuth, :ensure_authenticated}] do
        live "/profile", ProfileLive, :index
      end
  """
  def on_mount(:mount_current_user, _params, session, socket) do
    {:cont, mount_current_user(session, socket)}
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    socket = mount_current_user(session, socket)
    socket = mount_current_user_holds(session, socket)
    socket = mount_state_id(socket)
    socket = mount_mailbox_pid(socket)
    socket = mount_current_user_published_ids(session, socket)
    socket = mount_legiscan_keys(session, socket)
    socket = mount_use_local_data(socket.assigns.current_user.state, socket)
    # socket = mount_current_user_post_ids(session, socket)

    if socket.assigns.current_user do
      # IO.puts("subscribing")
      # subscribe_all(socket)
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must log in to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/users/log_in")

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_user_is_authenticated, _params, session, socket) do
    socket = mount_current_user(session, socket)

    if socket.assigns.current_user do
      {:halt, Phoenix.LiveView.redirect(socket, to: signed_in_path(socket))}
    else
      {:cont, socket}
    end
  end

  defp mount_current_user_holds(session, socket) do
      Phoenix.Component.assign_new(socket, :current_user_holds, fn ->
      if user_token = session["user_token"] do
        Accounts.get_all_holds_by_token(user_token)
      end
    end)
  end

  defp mount_state_id(socket) do
      Phoenix.Component.assign_new(socket, :state_id, fn ->
        Enum.with_index(Utils.states)
        |> Enum.find(fn {x,y} -> x == socket.assigns.current_user.state end)
        |> Kernel.elem(1)
        |> Kernel.+(1)
    end)
  end

  defp mount_mailbox_pid(socket) do
      {:ok, pid} = GenServer.start_link(FanCan.Mailbox, %{})
      FanCanWeb.Endpoint.subscribe("user" <> "_" <> socket.assigns.current_user.id)
      Logger.info("The Pid: #{inspect pid} and Registered to user_#{socket.assigns.current_user.id}", ansi_color: :magenta_background)
      # Dont need a new one each time
      :ets.insert(:mailbox_registry, {socket.assigns.current_user.id, pid})
      Phoenix.Component.assign(socket, :mailbox_pid, pid)
  end

  defp mount_use_local_data(state, socket) do
      {_id, pid} = :ets.lookup(:mailbox_registry, socket.assigns.current_user.id) |> List.first()
      # Send message to mailbox
      GenServer.cast(pid, {:put, :some_id, "now its a string message for :some_id"})
      Phoenix.Component.assign_new(socket, :use_local_data, fn ->
      # if state in Utils.states do
        case Public.state_records_exist?(state) do
          true -> true
          false -> false
        end
      # end
    end)
  end

  defp mount_legiscan_keys(session, socket) do
      mount_use_local_data(socket.assigns.current_user.state, socket)
      Phoenix.Component.assign_new(socket, :legiscan_keys, fn ->
      if user_token = session["user_token"] do
        user = Accounts.get_user_by_session_token(user_token)
        IO.puts("LegiScan")
        {:ok, resp} =
          Finch.build(:get, "https://api.legiscan.com/?key=#{System.fetch_env!("LEGISCAN_KEY")}&op=getSessionList&state=#{user.state}")
          |> Finch.request(FanCan.Finch)

        {:ok, body} = Jason.decode(resp.body)

        # IO.inspect(body["offices"], label: "Offices")
        # IO.inspect(body, label: "legiscan")
        # First one will be the current one
        List.first(body["sessions"])
      end
    end)
  end

  defp mount_current_user_published_ids(session, socket) do
      Phoenix.Component.assign_new(socket, :current_user_published_ids, fn ->
      if user_token = session["user_token"] do
        thread_ids = Accounts.get_user_thread_ids_by_token(user_token)
        post_ids = Accounts.get_user_post_ids_by_token(user_token)

        %{thread_ids: thread_ids, post_ids: post_ids}
      end
    end)
  end

  defp subscribe_all(socket) do
    IO.puts("casing casting")
    GenServer.cast(FanCanWeb.SubscriptionServer, {:subscribe_user_holds, socket.assigns.current_user_holds})
    GenServer.cast(FanCanWeb.SubscriptionServer, {:subscribe_user_published, socket.assigns.current_user_published_ids})
    # for follow = %UserHolds{} <- socket.assigns.current_user_holds do
    #   IO.inspect(follow, label: "Type")
    #   # Subscribe to user_holds. E.g. forums that user subscribes to
    #   case follow.type do
    #     :candidate -> TopicHelpers.subscribe_to_holds("candidate", follow.follow_ids)
    #     :user -> TopicHelpers.subscribe_to_holds("user", follow.follow_ids)
    #     :forum -> TopicHelpers.subscribe_to_holds("forum", follow.follow_ids)
    #     :election -> TopicHelpers.subscribe_to_holds("election", follow.follow_ids)
    #   end
    # end

    # with %{post_ids: post_ids, thread_ids: thread_ids} <- socket.assigns.current_user_published_ids do
    #   IO.inspect(thread_ids, label: "thread_ids_b")
    #   for post_id <- post_ids do
    #     FanCanWeb.Endpoint.subscribe("posts_" <> post_id)
    #   end
    #   for thread_id <- thread_ids do
    #     FanCanWeb.Endpoint.subscribe("threads_" <> thread_id)
    #   end
    # end
  end

  # defp mount_current_user_post_ids(session, socket) do
  #     Phoenix.Component.assign_new(socket, :current_user_thread_ids, fn ->
  #     if user_token = session["user_token"] do
  #       Accounts.get_user_holds_by_token(user_token)
  #     end
  #   end)
  # end

  defp mount_current_user(session, socket) do
    Phoenix.Component.assign_new(socket, :current_user, fn ->
      if user_token = session["user_token"] do
        Accounts.get_user_by_session_token(user_token)
      end
    end)
  end

  @doc """
  Used for routes that require the user to not be authenticated.
  """
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the user to be authenticated.

  If you want to enforce the user email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: ~p"/users/log_in")
      |> halt()
    end
  end

  def require_admin_role(conn, _opts) do
    if conn.assigns.current_user.role == :admin do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to view this page")
      |> maybe_store_return_to()
      |> redirect(to: ~p"/users/log_in")
      |> halt()
    end
  end

  defp put_token_in_session(conn, token) do
    conn
    |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(_conn), do: ~p"/"

  @impl true
  def handle_info(%{event: "new_message", payload: new_message}, socket) do
    IO.inspect(new_message.type, label: "New Message.type")
    updated_messages = socket.assigns[:messages] ++ [new_message]
    IO.inspect(new_message, label: "New Message")

    {:noreply,
     socket
     |> assign(:messages, updated_messages)
     |> put_flash(new_message.type, "PubSub: #{new_message.string}")}
  end
end
