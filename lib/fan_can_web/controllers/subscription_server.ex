defmodule FanCanWeb.SubscriptionServer do
  use GenServer
  alias FanCan.Core.TopicHelpers
  alias FanCan.Accounts.UserHolds
  alias FanCan.Core.Holds
  
  def start do
    initial_state = []
    receive_messages(initial_state)
  end

  def receive_messages(state) do
    receive do
      msg ->
        {:ok, new_state} = handle_message(msg, state)
        receive_messages(new_state)
    end
  end

  def handle_message({:subscribe_user_holds, user_holds}, state) do
    for follow = %Holds{} <- user_holds do
      IO.inspect(follow, label: "Type")
      # Subscribe to user_holds. E.g. forums that user subscribes to
      case follow.type do
        :candidate -> TopicHelpers.subscribe_to_holds("candidate", follow.follow_ids)
        :user -> TopicHelpers.subscribe_to_holds("user", follow.follow_ids)
        :forum -> TopicHelpers.subscribe_to_holds("forum", follow.follow_ids)
        :election -> TopicHelpers.subscribe_to_holds("election", follow.follow_ids)
      end
    end
    {:ok, []}
  end

  def handle_message({:subscribe_user_published, current_user_published_ids}, state) do
    with %{post_ids: post_ids, thread_ids: thread_ids} <- current_user_published_ids do
      IO.inspect(thread_ids, label: "thread_ids_b")
      for post_id <- post_ids do
        FanCanWeb.Endpoint.subscribe("posts_" <> post_id)
      end
      for thread_id <- thread_ids do
        FanCanWeb.Endpoint.subscribe("threads_" <> thread_id)
      end
    end
    {:ok, []}
  end

  def handle_message(_, state) do
    IO.puts "Updated"
    {:ok, []}
  end

  def handle_info(_) do
    IO.puts "Info Handler"
    {:ok, []}
  end

  def handle_cast(_) do
    IO.puts "Info Handler"
    {:noreply, []}
  end

  def handle_cast({:new_message, element}, state) do
    IO.inspect(state, label: "Concuerror - State var")
    IO.inspect(element, label: "Concuerror - Element var")
    if String.contains?(element, "b") do
      String.upcase(element)
    end
    {:noreply, [element | state]}
  end

  # def handle_cast(_, state) do
  #   IO.puts "Info Handler"
  #   {:noreply, state}
  # end

  def handle_message({:send_all_values, pid}, state) do
    send(pid, {:all_values, state})
    {:ok, state}
  end

  # @impl true
  # def handle_cast({:subscribe_user_holds, user_holds}, _subscriptions) do
  #   IO.puts("CASTCASTCAST")
  #   for follow = %UserHolds{} <- user_holds do
  #     IO.inspect(follow, label: "Type")
  #     # Subscribe to user_holds. E.g. forums that user subscribes to
  #     case follow.type do
  #       :candidate -> TopicHelpers.subscribe_to_holds("candidate", follow.follow_ids)
  #       :user -> TopicHelpers.subscribe_to_holds("user", follow.follow_ids)
  #       :forum -> TopicHelpers.subscribe_to_holds("forum", follow.follow_ids)
  #       :election -> TopicHelpers.subscribe_to_holds("election", follow.follow_ids)
  #     end
  #   end
  #   {:reply, user_holds}
  # end

  # @impl true
  # def handle_cast({:subscribe_user_published, current_user_published_ids}, _subscriptions) do
  #   IO.puts("CASTCASTCAST")
  #   with %{post_ids: post_ids, thread_ids: thread_ids} <- current_user_published_ids do
  #     IO.inspect(thread_ids, label: "thread_ids_b")
  #     for post_id <- post_ids do
  #       FanCanWeb.Endpoint.subscribe("posts_" <> post_id)
  #     end
  #     for thread_id <- thread_ids do
  #       FanCanWeb.Endpoint.subscribe("threads_" <> thread_id)
  #     end
  #   end
  #   {:reply, current_user_published_ids}
  # end

  # def handle_call({:jesus}, _from, state) do
  #   IO.puts("jesus")
  #   {:reply, state}
  # end

  # def handle_call({:get, key}, _from, state) do
  #   {:reply, Map.fetch!(state, key), state}
  # end
end
