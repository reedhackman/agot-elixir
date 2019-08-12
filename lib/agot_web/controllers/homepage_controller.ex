defmodule AgotWeb.HomepageController do
  use AgotWeb, :controller
  alias Agot.Players
  alias Agot.Decks
  alias Agot.Cache

  def index(conn, _params) do
    players =
      case Cache.get_top_ten("players") do
        nil ->
          players = Players.top_ten_players()
          Cache.put_top_ten("players", players)
          players

        players ->
          players
      end

    decks =
      case Cache.get_top_ten("decks") do
        nil ->
          decks = Decks.top_ten_quarter()
          Cache.put_top_ten("decks", decks)
          decks

        decks ->
          decks
      end

    render(conn, "index.html", %{players: players, decks: decks})
  end
end
