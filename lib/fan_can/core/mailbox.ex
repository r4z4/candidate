defmodule FanCan.Mailbox do
  use GenServer
  require Logger
  @name __MODULE__
  # Callbacks

  @impl true
  def init(kv \\ %{}) do
    Logger.info("Init", ansi_color: :yellow_background)
    {:ok, kv}
  end

  @impl true
  def handle_call({:get, key}, _from, kv) do
    Logger.info("Handling call. Keeping all messages unless user actively removes.", ansi_color: :red_background)
    # {val, remainder} = Map.pop!(stack, key)
    # Reply with message, and return new kv which is kv minus this message
    # {:reply, val, remainder}
    val = Map.fetch!(kv, key)
    {:reply, val, kv}
  end

  @impl true
  def handle_cast({:put, key, value}, kv) do
    Logger.info("Handling this cast", ansi_color: :green_background)
    {:noreply, Map.put(kv, key, value)}
  end
end

