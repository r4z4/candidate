defmodule FanCanWeb.Authorize do
  use Phoenix.Controller
  alias FanCanWeb.Router.Helpers,  as: Routes
  import FanCan.Accounts.Authorize, only: [read?: 2, get_permissions: 1, create?: 2, edit?: 2, delete?: 2]
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    role = conn.assigns.current_user.role
    resource = Keyword.get(opts, :resource)
    action = action_name(conn)

    check(action, role, resource)
    |> maybe_continue(conn)
  end

  defp maybe_continue(true, conn), do: conn

  defp maybe_continue(false, conn) do
    conn
    |> put_flash(:error, "Not authorized")
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end

  defp check(:index, role, resource) do
    get_permissions(role) |> read?(resource)
  end
  defp check(action, role, resource) when action in [:new, :create] do
    get_permissions(role) |> create?(resource)
  end
  defp check(action, role, resource) when action in [:edit] do
    get_permissions(role) |> edit?(resource)
  end
  defp check(:index, role, resource) do
    get_permissions(role) |> delete?(resource)
  end
  defp check(_action, _role, _resource), do: false
end