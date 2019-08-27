defmodule AgotWeb.GamesApiController do
  use AgotWeb, :controller
  alias Agot.Games

  def range(conn, params) do
    start_date = NaiveDateTime.from_iso8601(params["start"] <> " 00:00:00") |> Kernel.elem(1)
    end_date = NaiveDateTime.from_iso8601(params["end"] <> " 23:59:59") |> Kernel.elem(1)

    games =
      Games.list_games_for_interval(start_date, end_date)
      |> Enum.map(fn x ->
        %{
          winner_faction: x.winner_faction,
          winner_agenda: x.winner_agenda,
          loser_faction: x.loser_faction,
          loser_agenda: x.loser_agenda,
          date: NaiveDateTime.to_date(x.tournament_date)
        }
      end)

    conn
    |> put_status(200)
    |> json(%{games: games})
  end
end
