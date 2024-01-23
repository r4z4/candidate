defmodule FanCanWeb.Components.StateSnapshot do
  use Phoenix.Component

  # This API sucks. & can't get real IP from Docker.

  def display(assigns) do
    ~H"""
      <section>
          <section class="text-white body-font">
              <div class="container px-5 py-24 mx-auto">
                  <div class="p-5 bg-slate-700 flex items-center mx-auto border-2  mb-10 border-white rounded-lg sm:flex-row flex-col">
                  <div class="text-base md:text-sm sm:text-xs flex-grow sm:text-left text-center mt-6 sm:mt-2">
                    <div class="h-20 w-auto sm:mr-10 items-center justify-center flex-shrink-0">
                        <h1 class="text-black text-center text-2xl title-font font-bold mb-2">State Snapshot</h1>
                        <p class="leading-relaxed text-base md:text-sm sm:text-xs text-center">Highlights of current action in your state surrouding local, state and national elections.</p>
                        <img class="m-auto text-center w-5/5" src={"/images/state_svg/#{Atom.to_string(@state) |> String.downcase()}/outline.svg"} />
                      </div>
                      <div class="py-4">
                          <div class=" inline-block mr-2" >
                              <div class="flex pr-2 h-full items-center">
                                  <svg class="text-yellow-500 w-6 h-6 mr-1"  width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                      <path stroke="none" d="M0 0h24v24H0z"/>
                                      <circle cx="12" cy="12" r="9" />
                                      <path d="M9 12l2 2l4 -4" />
                                  </svg>
                                  <p class="title-font font-medium">Python</p>
                              </div>
                          </div>
                          <div class="inline-block mr-2" >
                              <div class="flex pr-2 h-full items-center">
                                  <svg class="text-yellow-500 w-6 h-6 mr-1"  width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                      <path stroke="none" d="M0 0h24v24H0z"/>
                                      <circle cx="12" cy="12" r="9" />
                                      <path d="M9 12l2 2l4 -4" />
                                  </svg>
                                  <p class="title-font font-medium">C</p>
                              </div>
                          </div>
                          <div class=" inline-block mr-2" >
                              <div class="flex pr-2 h-full items-center">
                                  <svg class="text-yellow-500 w-6 h-6 mr-1"  width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                      <path stroke="none" d="M0 0h24v24H0z"/>
                                      <circle cx="12" cy="12" r="9" />
                                      <path d="M9 12l2 2l4 -4" />
                                  </svg>
                                  <p class="title-font font-medium">Php</p>
                              </div>
                          </div>
                          <div class=" inline-block mr-2" >
                              <div class="flex pr-2 h-full items-center">
                                  <svg class="text-gray-500 w-6 h-6 mr-1"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round">
                                      <circle cx="12" cy="12" r="10" />
                                      <line x1="15" y1="9" x2="9" y2="15" />
                                      <line x1="9" y1="9" x2="15" y2="15" />
                                  </svg>
                                  <p class="title-font font-medium">Swift</p>
                              </div>
                          </div>

                          <div class=" inline-block mr-2" >
                              <div class="flex pr-2 h-full items-center">
                                  <svg class="text-gray-500 w-6 h-6 mr-1"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round">
                                      <circle cx="12" cy="12" r="10" />
                                      <line x1="15" y1="9" x2="9" y2="15" />
                                      <line x1="9" y1="9" x2="15" y2="15" />
                                  </svg>
                                  <p class="title-font font-medium">Java</p>
                              </div>
                          </div>
                          <div class=" inline-block mr-2" >
                              <div class="flex pr-2 h-full items-center">
                                  <svg class="text-gray-500 w-6 h-6 mr-1"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round">
                                      <circle cx="12" cy="12" r="10" />
                                      <line x1="15" y1="9" x2="9" y2="15" />
                                      <line x1="9" y1="9" x2="15" y2="15" />
                                  </svg>
                                  <p class="title-font font-medium">Javascript</p>
                              </div>
                          </div>
                      </div>
                      <div class="md:flex font-bold text-zinc-300">
                          <div class="w-full md:w-1/2 flex space-x-3">
                              <div class="w-1/2">
                                <%= for g <- @g_candidates["officials"] do %>
                                  <p><a href={ List.first(g["urls"]) }><%= g["name"] %></a></p>
                                <%= end %>
                              </div>
                              <div class="w-1/2">
                                <%= for g <- @g_candidates["officials"] do %>
                                  <p><%= g["party"] %></p>
                                <%= end %>
                              </div>
                          </div>
                          <div class="w-full md:w-1/2 flex space-x-3">
                              <div class="w-1/2">
                                <%= for g <- @g_candidates["officials"] do %>
                                <div :if={g["phones"]}>
                                  <p><%= List.first(g["phones"] || []) %></p>
                                </div>
                                <%= end %>
                              </div>
                              <div class="w-1/2">
                                <%= for g <- @g_candidates["officials"] do %>
                                <div :if={g["urls"]}>
                                  <p><%= List.first(g["urls"] || []) %></p>
                                </div>
                                <%= end %>
                              </div>
                          </div>
                      </div>
                      <a class="mt-3 text-amber-400 inline-flex items-center">Learn More
                      <svg fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="w-4 h-4 ml-2" viewBox="0 0 24 24">
                          <path d="M5 12h14M12 5l7 7-7 7"></path>
                      </svg>
                      </a>
                  </div>
                  </div>
              </div>
          </section>
      </section>
    """
  end
end
