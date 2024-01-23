defmodule FanCan.Presence do
  use Phoenix.Presence, otp_app: :fan_can,
                        pubsub_server: FanCan.PubSub
  
end