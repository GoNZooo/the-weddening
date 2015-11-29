defmodule Wedding.AuthPlug do
  import Plug.Conn, only: [get_session: 2]
  import Phoenix.Controller, only: [redirect: 2]
  alias Wedding.Router.Helpers

  def ensure_logged_in(conn, _params) do
    case get_session(conn, :logged_in) do
      nil -> redirect(conn, to: Helpers.session_path(conn, :new)) 
      _ -> conn
    end
  end
end
