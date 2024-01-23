defmodule FanCanWeb.ThreadLive.PostFormComponent do
  use FanCanWeb, :live_component

  alias FanCan.Site.Forum
  alias FanCan.Site.Forum.Post

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Let User @Whatever Know What You Think :)</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="post-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:thread_id]} type="hidden" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:author]} type="text" label="Author" readonly />
        <.input field={@form[:content]} type="textarea" label="Content" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Post</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{thread: thread, current_user: current_user} = assigns, socket) do
    post = %Post{thread_id: thread.id, author: current_user.id}
    changeset = Forum.change_post(post)
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign(:post, post)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Forum.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    save_post(socket, socket.assigns.action, post_params)
  end

  defp save_post(socket, :edit, post_params) do
    case Forum.update_post(socket.assigns.post, post_params) do
      {:ok, post} ->
        notify_parent({:saved, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_post(socket, :new_post, post_params) do
    case Forum.create_post(post_params) do
      {:ok, post} ->
        notify_parent({:saved, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_patch(to: ~p"/threads/#{post.thread_id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg) do 
    send(self(), {__MODULE__, msg})
    with {_, post = %Post{}} <- msg do
      # Add pubsub msg
      new_thread_post_message = %{type: :new_post, string: "New post added to thread #{post.thread_id} :)"}
      FanCanWeb.Endpoint.broadcast!("threads_" <> post.thread_id, "new_message", new_thread_post_message)
    end
  end
end
