defmodule FanCan.Repo.Migrations.AddBallotIndex do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS pg_trgm;")
    execute("CREATE INDEX ballot_vote_list ON ballots USING GIN (vote_map);")
  end

  def down do
    execute("DROP INDEX ballot_vote_list")
  end
end