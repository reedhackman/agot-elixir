defmodule AgotWeb.DeckController do
  use AgotWeb, :controller
  alias Agot.Decks

  def all(conn, _params) do
    stark = Decks.top_five_faction("Stark")
    baratheon = Decks.top_five_faction("Baratheon")
    lannister = Decks.top_five_faction("Lannister")
    greyjoy = Decks.top_five_faction("Greyjoy")
    targaryen = Decks.top_five_faction("Targaryen")
    martell = Decks.top_five_faction("Martell")
    tyrell = Decks.top_five_faction("Tyrell")
    nights_watch = Decks.top_five_faction("Night's Watch")
    free_folk = Decks.top_five_faction("The Free Folk")

    render(conn, "all.html", %{
      stark: stark,
      baratheon: baratheon,
      lannister: lannister,
      greyjoy: greyjoy,
      targaryen: targaryen,
      martell: martell,
      tyrell: tyrell,
      nights_watch: nights_watch,
      free_folk: free_folk
    })
  end

  def faction(conn, %{"faction" => faction}) do
    decks = Decks.list_decks_for_faction(faction)
    render(conn, "faction.html", %{faction: faction, decks: decks})
  end

  def agenda(conn, %{"faction" => faction, "agenda" => agenda}) do
    decks = Decks.list_matchups_for_deck(faction, agenda)
    render(conn, "agenda.html", decks: decks)
  end
end
