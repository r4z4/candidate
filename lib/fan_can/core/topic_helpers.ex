defmodule FanCan.Core.TopicHelpers do
  @moduledoc """
  Functions to help PubSub topics
  """

  def to_type(type_atom) do
    case type_atom do
      :candidate_holds -> "candidate"
      :user_holds -> "user"
      :forum_holds -> "forum"
      :election_holds -> "election"
      :race_holds -> "race"
      :thread_holds -> "thread"
      :post_holds -> "post"
    end
  end

  @doc """
  For each user_id in their holds list, subscribe
  """
  # user_234234sf-sdf34-sdfasdf-435435345 or candidate_234234sf-sdf34-sdfasdf-435435345 etc..
  def subscribe_to_holds(type_atom, list \\ []) do
    IO.inspect(list, label: "sub holds list")
    # string = type <> "_" <> "32453453-sdf4-sdf4-sdfs3"
    type = to_type(type_atom)
    # IO.inspect(string, label: "String")
    for i <- list, do: FanCanWeb.Endpoint.subscribe(type <> "_" <> i)
    # for i <- list do
    #   string = type <> "_" <> i
    #   FanCanWeb.Endpoint.subscribe(string)
    #   IO.puts "Subscribed to #{string}"
    # end
  end

  def underscore_keys(map = %{}) do
    map
    |> Enum.map(fn {k, v} -> {Macro.underscore(k), underscore_keys(v)} end)
    |> Enum.map(fn {k, v} -> {String.replace(k, "-", "_"), v} end)
    |> Enum.into(%{})
  end
end
