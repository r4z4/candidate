defmodule FanCanWeb.Components.AdminSnapshot do
  use Phoenix.Component

  # This API sucks. & can't get real IP from Docker.

  def display(assigns) do
    ~H"""
      <section>
          <section class="text-white body-font">
              <div class="container px-5 py-24 mx-auto">
                  <div class="p-5 bg-slate-700 flex items-center mx-auto border-2  mb-10 border-white rounded-lg sm:flex-row flex-col">
                    <h4>Admin Snapshot</h4>
                  </div>
              </div>
          </section>
      </section>
    """
  end
end