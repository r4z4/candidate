defmodule FanCanWeb.Components.CandidateSnapshot do
  use Phoenix.Component

  def display(assigns) do
    ~H"""
      <section>
          <section class="text-white body-font">
              <div class="container px-5 py-24 mx-auto">
                <div class="p-5 bg-slate-700 items-center mx-auto border-2 mb-10 border-white rounded-lg">
                  <h4 class="text-center">Your Mayor</h4>
                  <div class="text-base md:text-sm sm:text-xs text-center">
                      <div class="font-bold text-zinc-300">
                          <div class="">
                            <%= @mayor.f_name %> <%= @mayor.l_name %>
                          </div>
                          <div class="">
                            <%= @mayor.email %>
                          </div>
                          <div>
                            Up For Re-election: <%= @mayor.end_date %>
                          </div>
                          <div :if={@mayor.img_url} class="mt-6">
                            <img class="m-auto" src={@mayor.img_url} />
                          </div>
                      </div>
                  </div>
                </div>
              </div>
          </section>
      </section>
    """
  end
end