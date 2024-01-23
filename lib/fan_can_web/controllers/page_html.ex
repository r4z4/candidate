defmodule FanCanWeb.PageHTML do
  use FanCanWeb, :html
  alias Heroicons.LiveView
  alias FanCan.Core.Utils

  embed_templates "page_html/*"

  def map_zip do
    Enum.zip(Utils.states, Utils.state_names ++ Utils.territories)
  end
end
