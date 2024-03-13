defmodule FanCanWeb.Components.LegBallotEntry do
  use Phoenix.Component

  alias FanCan.Accounts
  alias FanCan.Core.TopicHelpers
  alias FanCan.Accounts.UserHolds
  alias FanCanWeb.Components.StateSnapshot
  alias FanCan.Core.Utils

  defp comprehend(list) do
    for x <- list do
      x.hold_cat_id
    end
  end

  defp party_class(party) do
    case party do
      "N" -> "ml-3 text-sky-300"
      "R" -> "ml-3 text-pink-300"
      "D" -> "ml-3 text-emerald-300"
      _ -> "ml-3 text-green"
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
          <h3 class="col-span-5 font-semibold text-sm leading-6 text-white h-5">
            <span class="ml-3 text-purple" :if={@ballot_race.district}>District: <%= @ballot_race.district %></span><span>Seat: <%= @ballot_race.seat %></span>
          </h3>
          <button type="button" phx-click="reset_ballot" phx-value-id={@ballot_race.id} phx-value-candidates={Enum.map(@ballot_race.candidates, fn x -> x.id end) |> List.to_string()}>
            <Heroicons.LiveView.icon name="arrow-path-rounded-square" type="outline" class="h-5 w-5 text-yellow-300 col-span-1 md:col-span-1" />
          </button>
        </div>
          <ul :for={candidate <- @ballot_race.candidates} class="mb-2">
          <button
            type="button"
            phx-click="vote_casted"
            phx-value-id={candidate.id}
            value={@ballot_race.district}
            class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
            disabled={voted_for?(candidate.id, assigns.vote_list)}
            ><div class="grid grid-cols-3 gap-0"><div><%= candidate.last_name %>, <%= candidate.first_name %></div><div class="inline"><span class={party_class(candidate.party)} :if={@ballot_race.district}>|| <%= candidate.party %></span></div><div class="inline"><img src={if voted_for?(candidate.id, assigns.vote_list), do: "/images/green_check_circle.svg", else: "/images/empty_circle.svg"} class="inline max-h-4" /></div></div></button>
          </ul>

          <div class="mt-2">
            <a href={"/races/inspect/#{@ballot_race.id}"}><Heroicons.LiveView.icon name="magnifying-glass" type="outline" class="h-5 w-5 inline text-white" /></a>
            <div class="inline w-auto bg-slate-700 rounded-md">
              <button type="button" disabled={Enum.any?(@race_holds, fn x -> x.type == :favorite end)} phx-click="action_click" phx-value-id={@ballot_race.id} phx-value-desc={@ballot_race.desc} phx-value-type={:favorite}><Heroicons.LiveView.icon name="star" type={if Enum.any?(@race_holds, fn x -> x.type == :favorite end), do: "solid", else: "outline"} class="h-5 w-5 text-yellow-300" /></button>
              <button type="button" disabled={Enum.any?(@race_holds, fn x -> x.type == :share end)} phx-click="action_click" phx-value-id={@ballot_race.id} phx-value-desc={@ballot_race.desc} phx-value-type={:share}><Heroicons.LiveView.icon name="share" type={if Enum.any?(@race_holds, fn x -> x.type == :share end), do: "solid", else: "outline"} class="h-5 w-5 text-white" /></button>
              <button type="button" disabled={Enum.any?(@race_holds, fn x -> x.type == :alert end)} phx-click="action_click" phx-value-id={@ballot_race.id} phx-value-desc={@ballot_race.desc} phx-value-type={:alert}><Heroicons.LiveView.icon name="bell" type={if Enum.any?(@race_holds, fn x -> x.type == :alert end), do: "solid", else: "outline"} class="h-5 w-5 text-yellow-300" /></button>
              <button type="button" disabled={Enum.any?(@race_holds, fn x -> x.type == :bookmark end)} phx-click="action_click" phx-value-id={@ballot_race.id} phx-value-desc={@ballot_race.desc} phx-value-type={:bookmark}><Heroicons.LiveView.icon name="bookmark" type={if Enum.any?(@race_holds, fn x -> x.type == :bookmark end), do: "solid", else: "outline"} class="h-5 w-5 text-orange-200" /></button>
            </div>
          </div>
      </div>
    """
  end

end
