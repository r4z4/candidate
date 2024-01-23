defmodule FanCanWeb.BallotLive.FormComponent do
  use FanCanWeb, :live_component

  alias FanCan.Public.Election

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="ballot-index-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:state]} type="text" label="State" />
        <.input field={@form[:year]} type="number" label="Year" />
        <.input
          field={@form[:races]}
          type="select"
          multiple
          label="Races"
          options={[]}
        />
        <.input field={@form[:columns]} type="number" label="Columns" />
        <.input field={@form[:attachment]} type="text" label="Attachment" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Ballot</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{ballot: ballot} = assigns, socket) do
    changeset = Election.change_ballot(ballot)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"ballot" => ballot_params}, socket) do
    changeset =
      socket.assigns.ballot
      |> Election.change_ballot(ballot_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"ballot" => ballot_params}, socket) do
    save_ballot(socket, socket.assigns.action, ballot_params)
  end

  defp save_ballot(socket, :edit, ballot_params) do
    case Election.update_ballot(socket.assigns.ballot, ballot_params) do
      {:ok, ballot} ->
        notify_parent({:saved, ballot})

        {:noreply,
         socket
         |> put_flash(:info, "Ballot updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_ballot(socket, :new, ballot_params) do
    case Election.create_ballot(ballot_params) do
      {:ok, ballot} ->
        notify_parent({:saved, ballot})

        {:noreply,
         socket
         |> put_flash(:info, "Ballot created successfully")
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
