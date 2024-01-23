defmodule FanCan.Repo do
  use Ecto.Repo,
    otp_app: :fan_can, adapter: Ecto.Adapters.Postgres
    use Scrivener, page_size: 100

    # in lib/my_app/repo.ex

  @on_load :load_atoms

  def load_atoms() do
    relevant_modules = [
      FanCan.Public.Legislator,
    ]
    
    Enum.each(relevant_modules, &Code.ensure_loaded?/1)
    :ok
  end
end
