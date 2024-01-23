defmodule FanCanWeb.RaceLive.FormComponent do
  use FanCanWeb, :live_component

  alias FanCan.Public.Election

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage race records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="race-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:candidates]}
          type="select"
          multiple
          label="Candidates"
          options={[]}
        />
        <.input field={@form[:seat]} type="text" label="Seat" />
        <.input field={@form[:year]} type="number" label="Year" />
        <.input field={@form[:election_date]} type="date" label="Election date" />
        <.input field={@form[:state]} type="text" label="State" />
        <.input field={@form[:elect_percentage]} type="number" label="Elect percentage" />
        <.input field={@form[:district]} type="number" label="District" />
        <.input
          field={@form[:attachments]}
          type="select"
          multiple
          label="Attachments"
          options={[]}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Race</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{race: race} = assigns, socket) do
    changeset = Election.change_race(race)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"race" => race_params}, socket) do
    changeset =
      socket.assigns.race
      |> Election.change_race(race_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"race" => race_params}, socket) do
    save_race(socket, socket.assigns.action, race_params)
  end

  defp save_race(socket, :edit, race_params) do
    case Election.update_race(socket.assigns.race, race_params) do
      {:ok, race} ->
        notify_parent({:saved, race})

        {:noreply,
         socket
         |> put_flash(:info, "Race updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_race(socket, :new, race_params) do
    case Election.create_race(race_params) do
      {:ok, race} ->
        notify_parent({:saved, race})

        {:noreply,
         socket
         |> put_flash(:info, "Race created successfully")
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
