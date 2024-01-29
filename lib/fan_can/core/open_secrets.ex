defmodule FanCan.Core.OpenSecrets do
  use Ecto.Schema

  schema "open_secret_legislator" do
    field :cid, :string
    field :firstlast, :string
    field :lastname, :string
    field :party, :string
    field :office, :string
    field :gender, :string
    field :first_elected, :string
    field :exit_code, :string
    field :comments, :string
    field :phone, :string
    field :fax, :string
    field :website, :string
    field :webform, :string
    field :congress_office, :string
    field :bioguide_id, :string
    field :votesmart_id, :string
    field :feccandid, :string
    field :twitter_id, :string
    field :youtube_url, :string
    field :facebook_id, :string
    field :birthdate, :string
  end

  # https://www.opensecrets.org/api/?method=candContrib&cid=N00050145&cycle=2022&output=json&apikey=8345e4735ec03ad87024bdd44a5583e1
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

  def candidate_data(cid, cycle \\ "2022", method \\ "candContrib") when is_binary(cid) do
      # state_str = get_state_str(state)
      output = "json"
      {:ok, resp} =
        Finch.build(:get, "https://www.opensecrets.org/api/?method=#{method}&cid=#{cid}&cycle=#{cycle}&output=#{output}&apikey=#{System.fetch_env!("OPEN_SECRETS_API_KEY")}")
        |> Finch.request(FanCan.Finch)


      {:ok, body} = Jason.decode(resp.body)
      IO.inspect(body, label: "Body")

      case method do
        "candContrib" ->
          %{"candidate_data" => body["response"]["contributors"]["@attributes"]}
        "candSummary" ->
          %{"candidate_data" => body["response"]["summary"]["@attributes"]}
        _ ->
          %{"candidate_data" => body["response"]["contributors"]["@attributes"]}
      end
    end
end

defmodule FanCan.Core.OpenSecretsContribution do
  defstruct [:org_name, :total, :pacs, :indivs]
end

defmodule FanCan.Core.OpenSecretsContribAttrs do
  use Ecto.Schema
  schema "open_secret_contrib_attrs" do
    field :attributes, :map
  end
end

defmodule FanCan.Core.OpenSecretsCandidateContrib do
  use Ecto.Schema
  schema "open_secret_candidate_contrib" do
    field :cand_name, :string
    field :cid, :string
    field :cycle, :string
    field :origin, :string
    field :source, :string
    field :notice, :string
    field :contributor, {:array, :map}
  end
end
