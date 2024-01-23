defmodule FanCan.EctoLogger do
  require Logger
  def handle_event([fan_can, :repo, :query], %{query_time: time}, %{query: query, params: params}, _config) do
    # time_ms = System.convert_time_unit(time, :native, :millisecond)
    # # head will be first 6 bits
    # # Need to do 5 because of "begin" queries
    # <<head :: binary-size(5)>> <> rest = query
    # case head do
    #   "SELEC" -> Logger.info("Query time: #{time_ms} with Query: #{query}", ansi_color: :yellow)
    #   "INSER" -> Logger.info("Query time: #{time_ms} with Query: #{query}", ansi_color: :magenta)
    #   "CREAT" -> Logger.info("Query time: #{time_ms} with Query: #{query}", ansi_color: :green)
    #   "UPDAT" -> Logger.info("Query time: #{time_ms} with Query: #{query}", ansi_color: :blue)
    #   _        -> Logger.info("Unknown Category Query time: #{time_ms} with Query: #{query}", ansi_color: :red)
    # end
    :ok
  end
  # Catch all
  def handle_event(_event, _, _metadata, _config) do
    # Uses this to debug when we forgot to add the _config arg
    Logger.info(binding())
  end
end