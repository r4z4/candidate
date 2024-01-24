defmodule FanCanWeb.Components.MailboxClient do
  use Phoenix.Component

  def display(assigns) do
    ~H"""
      <section>
          <section class="text-white body-font">
              <div class="container px-5 py-24 mx-auto">
                  <div class="p-5 bg-slate-700 flex items-center mx-auto border-2 mb-10 border-white rounded-lg sm:flex-row flex-col">
                    <ul id="message_list" class="">
                      <%= for message <- @messages do %>
                        <li class={"#{if message.read, do: 'border-2 border-sky-500'}"}}>
                          <details class="open:bg-slate-900 duration-300">
                            <summary class="bg-inherit px-5 py-3 text-sm cursor-pointer" phx-click="mark_read" phx-value-id={ message.id } phx-value-read={ message.read }>
                              <%= message.updated_at %> || From: <%= message.from_name %> | <b class="text-green-400">Subject:</b> <%= message.subject %>
                            </summary>
                            <div class="px-5 py-3 border border-gray-300 text-sm font-light">
                                <p><%= message.text %></p>
                            </div>
                          </details>
                        </li>
                      <% end %>
                    </ul>
                  </div>
              </div>
          </section>
      </section>
    """
  end
end
