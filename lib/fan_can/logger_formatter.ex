defmodule FanCan.LoggerFormatter do
  def format(level, message, timestamp, metadata) do
    log_event =
      to_json(
        %{
          timestamp: format_timestamp(timestamp),
          level: level,
          message: :erlang.iolist_to_binary(message),
          metadata: encode_metadata(metadata)
        }
      )
    Jason.encode!(log_event)
  rescue
    _ -> "could not format: #{inspect({level, message, timestamp, metadata})}"
  end

  # not every Erlang term is valid json, convert here
  defp to_json(x) do
    x
  end 

  defp encode_metadata(m) do
    Enum.map(m, fn {k,v} -> %{k => Tuple.to_list(v)} end)
  end
  # Not working
  defp format_timestamp(ts) do
    if ts do
      date = "#{Kernel.elem(Kernel.elem(ts, 0), 0)}-#{Kernel.elem(Kernel.elem(ts, 0), 1)}-#{Kernel.elem(Kernel.elem(ts, 0), 2)}"
      time = "#{Kernel.elem(Kernel.elem(ts, 1), 0)}:#{Kernel.elem(Kernel.elem(ts, 1), 1)}:#{Kernel.elem(Kernel.elem(ts, 1), 2)}:#{Kernel.elem(Kernel.elem(ts, 1), 3)}"
      date <> "T" <> time
    end
  end
end