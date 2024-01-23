defmodule FanCan.Repo.Migrations.AddAuthorizationIndex do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS pg_trgm;")
    execute("CREATE INDEX authorization_roles_read ON authorize USING GIN (read);")
    execute("CREATE INDEX authorization_roles_update ON authorize USING GIN (edit);")
    execute("CREATE INDEX authorization_roles_delete ON authorize USING GIN (delete);")
  end

  def down do
    execute("DROP INDEX authorization_roles_read")
    execute("DROP INDEX authorization_roles_edit")
    execute("DROP INDEX authorization_roles_delete")
  end
end