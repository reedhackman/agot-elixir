defmodule AgotWeb.PlayersController do
  use AgotWeb, :controller
  alias Agot.Players

  def all(conn, _params) do
    render(conn, "all.html")
  end
end
