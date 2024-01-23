defmodule FanCanWeb.Components.BallotEntry do
  use Phoenix.Component

  alias FanCan.Accounts
  alias FanCan.Core.TopicHelpers
  alias FanCan.Accounts.UserHolds
  alias FanCanWeb.Components.StateSnapshot
  alias FanCan.Core.Utils

  attr :ballot_race, :map, default: nil
  attr :district, :integer, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

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

  def voted_for?(id, holds) do
    Enum.member?(holds, id)
  end
  
  def display(assigns) do
    ~H"""
      <!--<img class="h-56 lg:h-60 w-full object-cover" src={@ballot_race.image_path} alt="" />-->
      <div class="p-2">
        <div class="grid grid-cols-6 mb-2">
          <h3 class="col-span-5 font-semibold text-lg leading-6 text-white h-5">
            <span class="ml-3 text-purple" :if={@ballot_race.district}>District: <%= @ballot_race.district %></span>
          </h3>
          <Heroicons.LiveView.icon name="arrow-path-rounded-square" type="outline" class="h-5 w-5 text-yellow-300 col-span-1 md:col-span-1" />
        </div>
          <ul :for={candidate <- @ballot_race.candidates} class="mb-2">
          <button
            type="button"
            phx-click="vote_casted" 
            phx-value-id={candidate.id}
            value={@ballot_race.district}
            class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
            disabled={voted_for?(candidate.id, assigns.vote_list)}
            ><div class="grid grid-cols-3 gap-0"><div><%= candidate.l_name %>, <%= candidate.f_name %><span class="text-xs text-orange" :if={candidate.incumbent_since}>(<%= String.slice(Date.to_string(candidate.incumbent_since), 0..3) %>)</span></div><div class="inline"><span class={party_class(candidate.party)} :if={@ballot_race.district}>|| <%= party_name(candidate.party) %></span></div><div class="inline"><img src={if voted_for?(candidate.id, assigns.vote_list), do: "/images/green_check_circle.svg", else: "/images/empty_circle.svg"} class="inline max-h-4" /></div></div></button>
          </ul>

          <div class="mt-2">
            <a href={"/races/inspect/#{@ballot_race.id}"}><Heroicons.LiveView.icon name="magnifying-glass" type="outline" class="h-5 w-5 inline text-white" /></a>
            <div class="inline w-auto bg-slate-700 rounded-md">
              <button phx-click="star_click" phx-value-id={@ballot_race.id}><Heroicons.LiveView.icon name="star" type="outline" class="h-5 w-5 text-yellow-300" /></button>
              <button phx-click="share_click" phx-value-id={@ballot_race.id}><Heroicons.LiveView.icon name="share" type="outline" class="h-5 w-5 text-white" /></button>
              <button phx-click="bell_click" phx-value-id={@ballot_race.id}><Heroicons.LiveView.icon name="bell" type="outline" class="h-5 w-5 text-yellow-300" /></button>
              <button phx-click="bookmark_click" phx-value-id={@ballot_race.id} phx-value-desc={@ballot_race.desc}><Heroicons.LiveView.icon name="bookmark" type="outline" class="h-5 w-5 text-orange-200" /></button>
            </div>
          </div>
      </div>
    """
  end


  def get_str(state) do
    Enum.zip(Utils.states, Utils.state_names ++ Utils.territories)
      |> Enum.find(fn {abbr,name} -> abbr == state end)
      |> Kernel.elem(1)
      |> Atom.to_string()
  end

end