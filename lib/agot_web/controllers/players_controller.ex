defmodule AgotWeb.PlayersController do
  use AgotWeb, :controller
  alias Agot.Players

  def all(conn, _params) do
    render(conn, "all.html")
  end

  def specific(conn, params) do
    player = Players.get_player(params["id"])
    render(conn, "specific.html", player: player)
  end

  def table(conn, _params) do
    players = Players.list_players()
    render(conn, "table.html", %{players: players, script_name: "table"})
  end
end
