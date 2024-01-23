defmodule FanCanWeb.CandidateLive.FormComponent do
  use FanCanWeb, :live_component

  alias FanCan.Public

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage candidate records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="candidate-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:prefix]}
          type="select"
          label="Prefix"
          prompt="Choose a value"
          options={Ecto.Enum.values(FanCan.Public.Candidate, :prefix)}
        />
        <.input field={@form[:f_name]} type="text" label="First name" />
        <.input field={@form[:l_name]} type="text" label="Last name" />
        <.input
          field={@form[:suffix]}
          type="select"
          label="Suffix"
          prompt="Choose a value"
          options={Ecto.Enum.values(FanCan.Public.Candidate, :suffix)}
        />
        <.input
          field={@form[:state]}
          type="select"
          label="State"
          prompt="Choose a value"
          options={Ecto.Enum.values(FanCan.Public.Candidate, :state)}
        />
        <.input
          field={@form[:birth_state]}
          type="select"
          label="Birth State"
          prompt="Choose a value"
          options={Ecto.Enum.values(FanCan.Public.Candidate, :birth_state)}
        />
        <.input field={@form[:district]} type="number" label="District" />
        <.input field={@form[:type]} type="text" label="Seat" />
        <.input
          field={@form[:party]}
          type="select"
          label="Party"
          prompt="Choose a value"
          options={Ecto.Enum.values(FanCan.Public.Candidate, :party)}
        />
        <.input field={@form[:cpvi]} type="text" label="CPVI" />
        <.input field={@form[:incumbent_since]} type="date" label="Incumbent since" />
        <.input field={@form[:dob]} type="date" label="DOB" />

        <.input
          field={@form[:attachments]}
          type="select"
          multiple
          label="Attachments"
          options={[]}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Candidate</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{candidate: candidate} = assigns, socket) do
    changeset = Public.change_candidate(candidate)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"candidate" => candidate_params}, socket) do
    changeset =
      socket.assigns.candidate
      |> Public.change_candidate(candidate_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"candidate" => candidate_params}, socket) do
    save_candidate(socket, socket.assigns.action, candidate_params)
  end

  defp save_candidate(socket, :edit, candidate_params) do
    case Public.update_candidate(socket.assigns.candidate, candidate_params) do
      {:ok, candidate} ->
        notify_parent({:saved, candidate})
        IO.inspect(socket, label: "socket")
        # assigns.user here is from <.live_component ... user={...} /> 
        updated_message = %{type: :candidate, string: "Candidate #{socket.assigns.candidate.l_name}, #{socket.assigns.candidate.f_name} Updated by #{socket.assigns.user.username}"}
        topic = "candidate_" <> candidate.id
        FanCanWeb.Endpoint.broadcast!(topic, "new_message", updated_message)
        IO.puts "Broadcasted to #{topic}"

        {:noreply,
         socket
         |> put_flash(:info, "Candidate updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_candidate(socket, :new, candidate_params) do
    case Public.create_candidate(candidate_params) do
      {:ok, candidate} ->
        notify_parent({:saved, candidate})
        new_message = %{type: :candidate, string: "Candidate #{socket.assigns.candidate.l_name}, #{socket.assigns.candidate.f_name} has entered the race! Candidate added by #{socket.assigns.user.username}"}
        FanCanWeb.Endpoint.broadcast!("candidate_" <> candidate.id, "new_message", new_message)

        {:noreply,
         socket
         |> put_flash(:info, "Candidate created successfully")
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
