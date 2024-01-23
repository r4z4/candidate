defmodule FanCanWeb.ForumLive.ThreadFormComponent do
  use FanCanWeb, :live_component

  alias FanCan.Site.Forum
  alias FanCan.Site.Forum.Thread

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage thread records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="thread-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:id]} type="hidden" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:forum_id]} value={@thread.forum_id} type="text" label="Forum" readonly type="hidden" />
        <.input field={@form[:creator]} value={@thread.creator} type="text" label="Author" readonly />
        <.input field={@form[:content]} type="textarea" label="Content" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Thread</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{forum: forum, current_user: current_user} = assigns, socket) do
    IO.puts("Update")
    thread = %Thread{forum_id: forum.id, creator: current_user.id}
    changeset = Forum.change_thread(thread)
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign(:thread, thread)}
  end

  @impl true
  def handle_event("validate", %{"thread" => thread_params}, socket) do
    IO.inspect(thread_params, label: "Thread Params Validate")
    changeset =
      socket.assigns.thread
      |> Forum.change_thread(thread_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"thread" => thread_params}, socket) do
    save_thread(socket, socket.assigns.action, thread_params)
  end

  defp save_thread(socket, :edit, thread_params) do
    case Forum.update_thread(socket.assigns.thread, thread_params) do
      {:ok, thread} ->
        notify_parent({:saved, thread})

        {:noreply,
         socket
         |> put_flash(:info, "Thread updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_thread(socket, :new_thread, thread_params) do
    IO.inspect(thread_params, label: "Thread Params")
    case Forum.create_thread(thread_params) do
      {:ok, thread} ->
        notify_parent({:saved, thread})

        {:noreply,
         socket
         |> put_flash(:info, "Thread created successfully")
         |> push_patch(to: ~p"/forums/main/#{thread.forum_id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("Error")
        IO.inspect(changeset, label: "Changeset")
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg) do 
    send(self(), {__MODULE__, msg})
    with {_, thread = %Thread{}} <- msg do
      # Add pubsub msg
      new_thread_thread_message = %{type: :new_thread, string: "New thread added to thread #{thread.id} :)"}
      FanCanWeb.Endpoint.broadcast!("threads_" <> thread.id, "new_message", new_thread_thread_message)
    end
  end
end
