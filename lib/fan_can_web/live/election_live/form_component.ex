defmodule FanCanWeb.ElectionLive.FormComponent do
  use FanCanWeb, :live_component

  alias FanCan.Public

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage election records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="election-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:year]} type="number" label="Year" />
        <.input field={@form[:state]} type="text" label="State" />
        <.input field={@form[:desc]} type="text" label="Desc" />
        <.input field={@form[:election_date]} type="date" label="Election date" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Election</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{election: election} = assigns, socket) do
    changeset = Public.change_election(election)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"election" => election_params}, socket) do
    changeset =
      socket.assigns.election
      |> Public.change_election(election_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"election" => election_params}, socket) do
    save_election(socket, socket.assigns.action, election_params)
  end

  defp save_election(socket, :edit, election_params) do
    case Public.update_election(socket.assigns.election, election_params) do
      {:ok, election} ->
        notify_parent({:saved, election})
        updated_message = %{type: :election, string: "Election #{socket.assigns.election.desc} has been edited by #{socket.assigns.user.username}"}
        FanCanWeb.Endpoint.broadcast!("election_" <> election.id, "new_message", updated_message)

        {:noreply,
         socket
         |> put_flash(:info, "Election updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_election(socket, :new, election_params) do
    case Public.create_election(election_params) do
      {:ok, election} ->
        notify_parent({:saved, election})
        new_message = %{type: :election, string: "Election #{socket.assigns.election.desc} has just been added by #{socket.assigns.user.username}"}
        FanCanWeb.Endpoint.broadcast!("election_" <> election.id, "new_message", new_message)

        {:noreply,
         socket
         |> put_flash(:info, "Election created successfully")
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
