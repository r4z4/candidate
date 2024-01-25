defmodule FanCanWeb.UserHoldsLive do
  use FanCanWeb, :live_view

  alias FanCan.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl text-zinc-200">
    <.header class="text-center">
      User Hold
      <:subtitle>Manage your user holds</:subtitle>
    </.header>

    <div :for={item <- @holds} class="list-decimal">
      <div>
        <p class="text-center"><%= Kernel.elem(item, 0) %></p>
        <div class="my-4">
          <div :for={hold <- Kernel.elem(item, 1)} class="list-disc ml-4">
            <p><span class={cat_class(hold.hold_cat)}><%= hold.hold_cat %></span>::<span class={type_class(hold.type)}><%= hold.type %></span> |> <%= hold.hold_cat_id %></p>
          </div>
        </div>
      </div>
    </div>
    </div>
    """
  end

  def cat_class(cat) do
    case cat do
      :candidate -> "text-green-700"
      :user -> "text-sky-700"
      :election -> "text-red-700"
      :forum -> "text-amber-700"
      :thread -> "text-purple-700"
      :post -> "text-orange-700"
      :race -> "text-fuchsia-700"
    end
  end

  def type_class(type) do
    case type do
      :follow -> "text-indigo-300"
      :star -> "text-cyan-300"
      :bookmark -> "text-lime-300"
      :alert -> "text-emerald-300"
      :vote -> "text-teal-300"
      :like -> "text-violet-300"
      :share -> "text-blue-300"
      :upvote -> "text-rose-300"
      :downvote -> "text-slate-300"
      :favorite -> "text-pink-300"
    end
  end

  @impl true
  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok,
      socket
      |> push_navigate(to: ~p"/users/settings")
      |> assign(:messages, [])}
  end

  @impl true
  def mount(_params, session, socket) do
    user = socket.assigns.current_user
    user_token = session["user_token"]
    holds = Accounts.get_all_holds_by_token(user_token)
    # IO.inspect(holds, label: "Ugh Holds")
    socket =
      socket
      |> assign(:holds, holds)

    {:ok, socket}
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
  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
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
  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
