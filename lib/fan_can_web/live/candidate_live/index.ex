defmodule FanCanWeb.CandidateLive.Index do
  use FanCanWeb, :live_view

  alias FanCan.Public
  alias FanCan.Public.Candidate
  alias FanCan.Accounts
  alias FanCan.Core.{TopicHelpers, Holds}
  import FanCan.Accounts.Authorize

  # @impl Phoenix.LiveView
  @impl true
  def mount(_params, _session, socket) do
    # {email, username} = Accounts.get_user_data_by_token(session["user_token"])
    # %{entries: entries, page_number: page_number, page_size: page_size, total_entries: total_entries, total_pages: total_pages}
    FanCanWeb.Endpoint.subscribe("topic")
    result = if connected?(socket), do: Public.paginate_candidates(), else: %Scrivener.Page{}

    for follow = %Holds{} <- socket.assigns.current_user_holds do
      IO.inspect(follow, label: "Type")
      # Subscribe to user_holds. E.g. forums that user subscribes to
      case follow.type do
        :candidate -> TopicHelpers.subscribe_to_holds("candidate", follow.follow_ids)
        :user -> TopicHelpers.subscribe_to_holds("user", follow.follow_ids)
        :forum -> TopicHelpers.subscribe_to_holds("forum", follow.follow_ids)
        :election -> TopicHelpers.subscribe_to_holds("election", follow.follow_ids)
      end
    end

    with %{post_ids: post_ids, thread_ids: thread_ids} <- socket.assigns.current_user_published_ids do
      IO.inspect(thread_ids, label: "thread_ids_b")
      for post_id <- post_ids do
        FanCanWeb.Endpoint.subscribe("posts_" <> post_id)
      end
      for thread_id <- thread_ids do
        FanCanWeb.Endpoint.subscribe("threads_" <> thread_id)
      end
    end

    loc_info = get_voter_info(socket.assigns.current_user)
    
    
    {:ok, 
     socket
     |> stream(:candidates, result.entries)
     |> stream(:stream_messages, [])
     |> assign(:loc_info, loc_info)
     |> assign(:page_number, result.page_number || 0)
     |> assign(:page_size, result.page_size || 0)
     |> assign(:total_entries, result.total_entries || 0)
     |> assign(:total_pages, result.total_pages || 0)}
  end

  defp get_voter_info(user) do
    IO.inspect(user, label: "User in Voter Info")
    {:ok, resp} = 
      Finch.build(:get, "https://civicinfo.googleapis.com/civicinfo/v2/voterinfo?address=12%20M%20#{user.city}%2C%20#{user.state}&electionId=2000&key=#{System.fetch_env!("GCLOUD_PROJECT")}") 
      |> Finch.request(FanCan.Finch)

    {:ok, body} = Jason.decode(resp.body)

    filtered = 
      Enum.filter(body["contests"], fn(contest) ->
        Map.has_key?(contest, "candidates")
      end)

    # IO.inspect(body, label: "Body")
    # IO.inspect(filtered, label: "Filtered")
    filtered
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Candidate")
    |> assign(:messages, [])
    |> assign(:candidate, Public.get_candidate!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Candidate")
    |> assign(:candidate, %Candidate{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Candidates")
    |> assign(:messages, [])
    |> assign(:candidate, nil)
  end

  defp apply_action(socket, :nav, %{"page_number" => page_number}) do
    socket
    |> assign(:page_number, page_number)
  end

  @impl true
  def handle_info({FanCanWeb.CandidateLive.FormComponent, {:saved, candidate}}, socket) do
    {:noreply, stream_insert(socket, :candidates, candidate)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    candidate = Public.get_candidate!(id)
    {:ok, _} = Public.delete_candidate(candidate)

    {:noreply, stream_delete(socket, :candidates, candidate)}
  end

  @impl true
  def handle_info(%{event: "new_message", payload: new_message}, socket) do
    updated_messages = socket.assigns[:messages] ++ [new_message]
    IO.inspect(new_message, label: "New Message")

    {:noreply, 
     socket 
     |> assign(:messages, updated_messages)
     |> put_flash(:info, "PubSub: #{new_message}")}
  end

  def handle_params(_, _, socket) do
    assigns = get_and_assign_page(nil)
    {:noreply, assign(socket, assigns)}
  end

  def get_and_assign_page(page_number) do
    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = Products.paginate_products(page: page_number)

    [
      products: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    ]
  end
end
