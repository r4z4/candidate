defmodule FanCanWeb.Components.BallotEntryForm do
  use Phoenix.Component

  alias FanCan.Accounts
  alias FanCan.Core.TopicHelpers
  alias FanCan.Accounts.UserHolds
  alias FanCanWeb.Components.StateSnapshot
  alias FanCan.Core.Utils

  attr :ballot_race, :map, default: nil
  attr :district, :integer, default: nil

  defp get_races(holds) do
    # Enum.filter(holds, fn x -> x.type == :races end)
    holds.race_holds
  end

  defp get_elections(holds) do
    holds.election_holds
  end

      defp comprehend(list) do
    for x <- list do
      x.hold_cat_id
    end
  end

  defp party_class(party) do
    case party do
      :Democrat -> "ml-3 text-sky-300"
      :Republican -> "ml-3 text-pink-300"
      :Independent -> "ml-3 text-emerald-300"
      :Now -> "ml-3 text-green"
      :Libertarian -> "ml-3 text-purple-200"
      :Non_Partisan -> "ml-3 text-fuchsia-300"
      :Other_Party -> "ml-3 text-amber"
    end
  end

  defp party_name(party) do
    case party do
      :Democrat -> "Dem"
      :Republican -> "Rep"
      :Independent -> "Ind"
      :Now -> "Now"
      :Libertarian -> "Lib"
      :Non_Partisan -> "Non-P"
      :Other_Party -> "Other"
    end
  end

  defp candidate_class(candidate) do
    case candidate.incumbent_since do
      _ -> "font-bold"
    end
  end

  @impl true
  def display(assigns) do
    ~H"""
      <form id={@ballot_race.id}>
      <!--<img class="h-56 lg:h-60 w-full object-cover" src={@ballot_race.image_path} alt="" />-->
      <div class="p-2">
          <h3 class="font-semibold text-sm leading-6 text-white my-2">
              <%= @ballot_race.seat %> <span class="ml-3 text-purple text-xs" :if={@ballot_race.district}>||  District: <%= @ballot_race.district %></span>
          </h3>
          <ul :for={candidate <- @ballot_race.candidates} class="">
            <li class="grid grid-cols-6 gap-0">
              <div class="col-span-5"><%= candidate.l_name %>, <%= candidate.f_name %><span class="text-xs text-orange" :if={candidate.incumbent_since}>(<%= String.slice(Date.to_string(candidate.incumbent_since), 0..3) %>)</span>
              <span class={party_class(candidate.party)} :if={@ballot_race.district}>|| <%= party_name(candidate.party) %></span></div>
              <div class="col-span-1">
              <input
                field={@ballot_race.district}
                id={candidate.id}
                type="radio"
                name={@ballot_race.district}
                phx-change={"vote_casted"}
                value={candidate.id}
                checked={false}
                label="Vote"
                options={[]}
              />
              </div>
            </li>
          </ul>
          <a href={"/races/inspect/#{@ballot_race.id}"}><Heroicons.LiveView.icon name="magnifying-glass" type="outline" class="h-5 w-5 inline text-white" /></a>
          <div class="inline w-auto bg-slate-700 rounded-md">
            <button phx-click="star_click" phx-value-id={@ballot_race.id}><Heroicons.LiveView.icon name="star" type="outline" class="h-5 w-5 text-yellow-300" /></button>
            <button phx-click="share_click" phx-value-id={@ballot_race.id}><Heroicons.LiveView.icon name="share" type="outline" class="h-5 w-5 text-white" /></button>
            <button phx-click="bell_click" phx-value-id={@ballot_race.id}><Heroicons.LiveView.icon name="bell" type="outline" class="h-5 w-5 text-yellow-300" /></button>
            <button phx-click="bookmark_click" phx-value-id={@ballot_race.id} phx-value-desc={@ballot_race.desc}><Heroicons.LiveView.icon name="bookmark" type="outline" class="h-5 w-5 text-orange-200" /></button>
          </div>
      </div>
      </form>
    """
  end

end
