defmodule AgotWeb.DeckController do
  use AgotWeb, :controller
  alias Agot.Decks
  alias Agot.Games

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

  def faction(conn, %{"faction" => faction, "sortby" => sortby, "order" => order}) do
    decks = Decks.list_decks_for_faction(faction)
    render(conn, "faction.html", %{faction: faction, decks: decks})
  end

  def agenda(conn, %{
        "faction" => faction,
        "agenda" => agenda,
        "sortby" => sortby,
        "order" => order
      }) do
    decks = Decks.list_matchups_for_deck(faction, agenda)
    render(conn, "agenda.html", %{faction: faction, agenda: agenda, decks: decks})
  end

  def react(conn, _params) do
    games =
      Games.list_games_with_agendas()
      |> Enum.map(fn x ->
        %{
          winner_faction: x.winner_faction,
          winner_agenda: x.winner_agenda,
          loser_faction: x.loser_faction,
          loser_agenda: x.loser_agenda,
          date: NaiveDateTime.to_date(x.tournament_date)
        }
      end)

    render(conn, "react.html", %{games: games, script_name: "decks"})
  end
end
