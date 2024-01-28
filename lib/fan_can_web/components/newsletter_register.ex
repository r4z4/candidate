defmodule FanCanWeb.Components.NewsletterRegister do
  use Phoenix.LiveComponent
  alias FanCanWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <CoreComponents.simple_form for={@newsletter_form} id="newsletter_form" phx-submit="register_newsletter">
      <CoreComponents.input field={@form[:email]} type="email" placeholder="Email" required />
      <:actions>
        <CoreComponents.button phx-disable-with="Sending..." class="w-full">
          Notify Me
        </CoreComponents.button>
      </:actions>
    </CoreComponents.simple_form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("register_newsletter", %{"user" => %{"email" => email}}, socket) do
    IO.inspect(email)

    {:noreply, socket}
  end
end
