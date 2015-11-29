defmodule Wedding.PageController do
  use Wedding.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
