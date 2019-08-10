defmodule AgotWeb.HomepageController do
  use AgotWeb, :controller
  alias Agot.Players
  alias Agot.Decks

  def index(conn, _params) do
    players = Players.top_ten_players()
    decks = Decks.top_ten_decks()
    render(conn, "index.html", %{players: players, decks: decks})
  end
end
