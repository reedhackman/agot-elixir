defmodule Agot.Tjp do
  use GenServer
  alias Agot.Analytica
  alias Agot.Games
  alias Agot.Tournaments

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :joust, 1000)
    {:ok, state}
  end

  def handle_info(:joust, state) do
    check_tjp()
    check_all_incomplete_age()
    check_all_remaining_incomplete()
    check_all_remaining_placements()
    Analytica.update_all_decks_three_months()
    Analytica.update_daily_cache()
    Process.send_after(self(), :joust, 1000 * 60 * 60 * 3)
    {:noreply, state}
  end

  def check_all_remaining_placements do
    with missing <- Tournaments.list_missing_placements() do
      missing
      |> Enum.each(fn x -> check_missing_placement(x) end)
    end
  end

  def check_all_remaining_incomplete do
    with incomplete <- Games.list_incomplete() do
      incomplete
      |> Enum.map(fn x -> x.tournament_id end)
      |> Enum.uniq()
      |> Enum.each(fn x -> check_tjp_tournament_game(x, incomplete) end)
    end
  end

  def check_all_incomplete_age do
    with incomplete <- Games.list_incomplete(),
         current_time <- NaiveDateTime.utc_now() do
      incomplete
      |> Enum.map(fn x -> x.tournament_id end)
      |> Enum.uniq()
      |> Enum.each(fn x -> check_tjp_tournament_age(x, current_time) end)
    end
  end

  def check_missing_placement(tournament) do
    url = "http://thejoustingpavilion.com/api/v3/tournaments/" <> Integer.to_string(tournament.id)

    case HTTPoison.get(url, [], follow_redirect: true) do
      {:ok, %{status_code: 200, body: body}} ->
        IO.inspect(url)
        data = Poison.decode!(body)

        players =
          data
          |> Enum.map(fn x -> x["player_id"] end)

        if tournament.players === [] do
          Enum.each(players, fn x -> Tournaments.add_player_to_tournament(tournament, x) end)
        end

        if List.first(data)["topx"] == 1 or
             NaiveDateTime.diff(NaiveDateTime.utc_now(), tournament.date) > 60 * 60 * 24 * 31 do
          Tournaments.update_tournament(tournament, %{standings: players})
        end

      {:error, _} ->
        nil
    end
  end

  def check_tournament_age(tournament, time) do
    end_time = tournament["end_time"]

    if end_time != nil do
      end_age = NaiveDateTime.diff(time, NaiveDateTime.from_iso8601!(end_time))

      if end_age > 60 * 60 * 24 * 31 do
        Games.delete_incomplete_tournament(tournament["tournament_id"])
      end
    else
      start_age = NaiveDateTime.diff(time, NaiveDateTime.from_iso8601!(tournament["start_time"]))

      if start_age > 60 * 60 * 24 * 365 do
        Games.delete_incomplete_tournament(tournament["tournament_id"])
      end
    end
  end

  def check_tjp_tournament_age(id, time) do
    url =
      "http://thejoustingpavilion.com/api/v3/tournaments?tournament_id=" <> Integer.to_string(id)

    case HTTPoison.get(url, [], follow_redirect: true) do
      {:ok, %{status_code: 200, body: body}} ->
        IO.inspect(url)

        Poison.decode!(body)
        |> List.first()
        |> check_tournament_age(time)
    end
  end

  def check_tjp_tournament_game(id, incomplete_games, list \\ [], page \\ 1) do
    url =
      "http://thejoustingpavilion.com/api/v3/games?tournament_id=" <>
        Integer.to_string(id) <> "&page=" <> Integer.to_string(page)

    case HTTPoison.get(url, [], follow_redirect: true) do
      {:ok, %{status_code: 200, body: body}} ->
        data = Poison.decode!(body)
        IO.inspect(url)

        if length(data) === 50 do
          check_tjp_tournament_game(id, incomplete_games, list ++ data, page + 1)
        end

        check_incomplete_games_by_tournament(list ++ data, id)
    end
  end

  def check_incomplete_games_by_tournament(tournament_games, tournament_id) do
    Games.list_incomplete_for_tournament(tournament_id)
    |> Enum.each(fn x -> check_incomplete(x.id, tournament_games) end)
  end

  def check_incomplete(game_id, tournament_games) do
    incomplete = Enum.find(tournament_games, fn x -> x["game_id"] == game_id end)

    if incomplete["game_status"] == 100 do
      Analytica.clean_and_process_game(incomplete)
      Games.delete_incomplete_game(game_id)
    end
  end

  def check_tjp do
    position = Agot.Misc.get_position()
    IO.inspect(position)
    check_games_by_page([], position.page_number, position.page_length)
  end

  def check_games_by_page(list \\ [], page \\ 1, i \\ 0) do
    url = "https://thejoustingpavilion.com/api/v3/games?page=" <> Integer.to_string(page)

    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        data = Poison.decode!(body)
        length = length(data)
        new_data = Enum.slice(data, i..length)
        IO.inspect(url <> " length: " <> Integer.to_string(length))

        if length === 50 do
          check_games_by_page(list ++ new_data, page + 1)
        else
          Analytica.process_all_games(list ++ new_data, page, length)
          IO.inspect(Integer.to_string(length(list ++ new_data)) <> " new games")
        end
    end
  end
end
