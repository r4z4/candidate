defmodule FanCanWeb.Components.PageNav do
  use Phoenix.Component

  # This API sucks. & can't get real IP from Docker.

  def display(assigns) do
    ~H"""
    <style>
      .hover\:w-full:hover {
          width: 100%;
      }
      .group:hover .group-hover\:w-full {
          width: 100%;
      }
      .group:hover .group-hover\:inline-block {
          display: inline-block;
      }
      .group:hover .group-hover\:flex-grow {
          flex-grow: 1;
      }
      </style>
      <div class="min-w-screen text-white flex items-center justify-center p-2">
          <div class="w-full max-w-md mx-auto">
              <div class="px-7 bg-slate-700 shadow-lg rounded-2xl">
                  <div class="flex">
                      <div class="flex-1 group">
                          <a href="#" class="flex items-end justify-center text-center mx-auto px-4 pt-2 w-full group-hover:text-indigo-500 border-b-2 border-transparent group-hover:border-indigo-500">
                              <span class="block px-1 pt-1 pb-2">
                                  <Heroicons.LiveView.icon name="star" type="outline" class="h-5 w-5 text-yellow-300" />
                                  <span class="block text-xs pb-1">Home</span>
                              </span>
                          </a>
                      </div>
                      <div class="flex-1 group">
                          <a href="#" class="flex items-end justify-center text-center mx-auto px-4 pt-2 w-full group-hover:text-indigo-500 border-b-2 border-transparent group-hover:border-indigo-500">
                              <span class="block px-1 pt-1 pb-2">
                                  <Heroicons.LiveView.icon name="star" type="outline" class="h-5 w-5 text-black" />
                                  <span class="block text-xs pb-1">Sort By</span>
                              </span>
                          </a>
                      </div>
                      <div class="flex-1 group">
                          <a href="#" class="flex items-end justify-center text-center mx-auto px-4 pt-2 w-full group-hover:text-indigo-500 border-b-2 border-transparent group-hover:border-indigo-500">
                              <span class="block px-1 pt-1 pb-2">
                                  <Heroicons.LiveView.icon name="clock" type="outline" class="h-5 w-5 text-black" />
                                  <span class="block text-xs pb-1">Last Updated</span>
                              </span>
                          </a>
                      </div>
                      <div class="flex-1 group">
                          <a href="#" class="flex items-end justify-center text-center mx-auto px-4 pt-2 w-full group-hover:text-indigo-500 border-b-2 border-transparent group-hover:border-indigo-500">
                              <span class="block px-1 pt-1 pb-2">
                                  <Heroicons.LiveView.icon name="star" type="outline" class="h-5 w-5 text-yellow-300" />
                                  <span class="block text-xs pb-1">Settings</span>
                              </span>
                          </a>
                      </div>
                  </div>
              </div>
          </div>
      </div>
    """
  end
end