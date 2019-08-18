defmodule AgotWeb.PlayerController do
  use AgotWeb, :controller
  alias Agot.Players
  alias Agot.Games

  def all(conn, _params) do
    players =
      Players.list_players()
      |> Enum.sort(&(&1.name <= &2.name))
      |> Enum.slice(0, 25)

    render(conn, "all.html", players: players)
  end

  def search(conn, params \\ %{}) do
    page_number =
      if params["page_number"] === "" do
        1
      else
        String.to_integer(params["page_number"])
      end

    num_rows = String.to_integer(params["num_rows"])

    players =
      Players.list_players_advanced(params["name"], params["case"], params["min_games"])
      |> Players.sort_players_by_name(params["asc"])
      |> Players.sort_players_by(params["sort"], params["asc"])
      |> Enum.slice((page_number - 1) * num_rows, num_rows)

    render(conn, "all.html", players: players)
  end

  def specific(conn, %{"id" => p_id}) do
    id = String.to_integer(p_id)
    player = Players.get_player_and_tournaments(id)

    games = Games.list_games_for_player(id)

    wins =
      games
      |> Enum.filter(fn x -> x.winner_id == id end)
      |> Enum.map(fn x ->
        %{
          opponent_id: x.loser_id,
          opponent_name: x.loser.name,
          opponent_rating: round(x.loser.rating),
          winner_faction: x.winner_faction,
          loser_faction: x.loser_faction,
          winner_agenda: x.winner_agenda,
          loser_agenda: x.loser_agenda
        }
      end)

    losses =
      games
      |> Enum.filter(fn x -> x.loser_id == id end)
      |> Enum.map(fn x ->
        %{
          opponent_id: x.winner_id,
          opponent_name: x.winner.name,
          opponent_rating: round(x.winner.rating),
          winner_faction: x.winner_faction,
          loser_faction: x.loser_faction,
          winner_agenda: x.winner_agenda,
          loser_agenda: x.loser_agenda
        }
      end)

    IO.inspect(player)

    tournaments =
      player.tournaments
      |> Enum.map(fn x -> %{name: x.name, id: x.id, standings: x.standings} end)

    render(conn, "specific.html", %{
      player: player,
      wins: wins,
      losses: losses,
      tournaments: tournaments,
      script_name: "players"
    })
  end

  def react(conn, _params) do
    players =
      Players.list_players()
      |> Enum.map(fn x ->
        %{
          id: x.id,
          name: x.name,
          rating: x.rating,
          percent: x.num_wins / (x.num_wins + x.num_losses),
          played: x.num_wins + x.num_losses,
          wins: x.num_wins,
          losses: x.num_losses
        }
      end)

    render(conn, "table.html", %{players: players, script_name: "players"})
  end
end
