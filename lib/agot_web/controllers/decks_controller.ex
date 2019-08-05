defmodule AgotWeb.DecksController do
  use AgotWeb, :controller
  alias Agot.Decks

  def all(conn, _params) do
    render(conn, "all.html")
  end

  def faction(conn, params) do
    render(conn, "faction.html")
  end

  def agenda(conn, params) do
    render(conn, "agenda.html")
  end
end
