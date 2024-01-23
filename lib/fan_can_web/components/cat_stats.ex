defmodule FanCanWeb.Components.CatStats do
  use Phoenix.Component

  # This API sucks. & can't get real IP from Docker.

  def display(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-center justify-center">
      <!-- Card -->
      <a href="#" class="w-auto border-2 border-white rounded-xl hover:bg-gray-50">
        <!-- Badge -->
        <p class="bg-sky-500 w-fit px-4 py-1 text-sm font-bold text-white rounded-tl-lg rounded-br-xl"> THIS FORUM </p>
        <div class="grid grid-cols-6 p-5 gap-y-2">
          <!-- Profile Picture -->
          <div>
            <img src={"/images/icons/vote_done_icon.svg"} class="max-w-16 max-h-16 rounded-full" />
          </div>
          <!-- Description -->
          <div class="col-span-5 md:col-span-4 ml-4">
            <p class="text-sky-500 font-bold text-xs"><%= @obj.category %></p>
            <p class="text-gray-600 font-bold"><%= @obj.title %></p>
            <p class="text-gray-400"><%= @obj.updated_at %></p>
            <p class="text-gray-400"># Members: <%= Kernel.length(@obj.members) %></p>
          </div>
          <!-- Price -->
          <div class="flex col-start-2 ml-4 md:col-start-auto md:ml-0 md:justify-end">
            <p class="rounded-lg text-sky-500 font-bold bg-sky-100  py-1 px-3 text-sm w-fit h-fit"> $ 5 </p>
          </div>
        </div>
      </a>
    </div>
    """
  end
end