defmodule FanCan.Core.OpenSecrets do
  # Use Abbr
  def get_legislators(state) do
    # state_str = get_state_str(state)
    output = "json"
    {:ok, resp} =
      Finch.build(:get, "https://www.opensecrets.org/api/?method=getLegislators&id=#{state}&output=#{output}&apikey=#{System.fetch_env!("OPEN_SECRETS_API_KEY")}")
      |> Finch.request(FanCan.Finch)


    {:ok, body} = Jason.decode(resp.body)
    IO.inspect(body, label: "Body")

    %{"legislator_list" => body["response"]["legislator"]}
  end
end
