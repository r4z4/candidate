defmodule FanCan.Repo.Migrations.CreateLegislatorsJsonIndex do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS pg_trgm;")
    execute("CREATE INDEX legislators_json_api_map ON legislators_json USING GIN (api_map);")
  end

  def down do
    execute("DROP INDEX legislators_json_api_map")
  end
end
