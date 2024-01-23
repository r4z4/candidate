defmodule FanCanWeb.StateLive.FormComponent do
  use FanCanWeb, :live_component

  alias FanCan.Public

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage state records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="state-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:id]} type="number" label="Id" />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:code]} type="text" label="Code" />
        <.input field={@form[:num_districts]} type="number" label="Num districts" />
        <:actions>
          <.button phx-disable-with="Saving...">Save State</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{state: state} = assigns, socket) do
    changeset = Public.change_state(state)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"state" => state_params}, socket) do
    changeset =
      socket.assigns.state
      |> Public.change_state(state_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"state" => state_params}, socket) do
    save_state(socket, socket.assigns.action, state_params)
  end

  defp save_state(socket, :edit, state_params) do
    case Public.update_state(socket.assigns.state, state_params) do
      {:ok, state} ->
        notify_parent({:saved, state})

        {:noreply,
         socket
         |> put_flash(:info, "State updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_state(socket, :new, state_params) do
    case Public.create_state(state_params) do
      {:ok, state} ->
        notify_parent({:saved, state})

        {:noreply,
         socket
         |> put_flash(:info, "State created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
