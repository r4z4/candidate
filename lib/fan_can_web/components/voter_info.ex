defmodule FanCanWeb.Components.VoterInfo do
  use Phoenix.Component

  # This API sucks. & can't get real IP from Docker.

  def display(assigns) do
    ~H"""
    <h4>Voter Info</h4>
      <div class="mt-10 space-y-8 bg-slate-700">
        <%=  %>
      </div>
    """
  end
end