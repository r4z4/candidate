defmodule FanCan.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Query here includes all queries. Tried :insert. Not needed.
    :ok = :telemetry.attach("ecto-logger", [:fan_can, :repo, :query], &FanCan.EctoLogger.handle_event/4, %{})
    :ets.new(:mailbox_registry, [:set, :public, :named_table])

    children = [
      # Start the Telemetry supervisor
      FanCanWeb.Telemetry,
      # Start the Ecto repository
      FanCan.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: FanCan.PubSub},
      FanCan.Presence,
      FanCan.ThinWrapper,
      # Start Finch
      {Finch, name: FanCan.Finch},
      # Start the Endpoint (http/https)
      FanCanWeb.Endpoint,
      {Task.Supervisor, name: FanCan.TaskSupervisor}
      # Start a worker by calling: FanCan.Worker.start_link(arg)
      # {FanCan.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FanCan.Supervisor]
    Supervisor.child_spec(%{id: Goth, start: {Goth, :start_link, []}}, id: Goth)
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FanCanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
