defmodule Agot.Games do
  alias Agot.Repo
  alias Agot.Games.Game
  alias Agot.Games.Incomplete
  alias Agot.Players

  import Ecto.Query

  def list_games_for_player(id) do
    query =
      from game in Game,
        left_join: winner in assoc(game, :winner),
        left_join: loser in assoc(game, :loser),
        preload: [winner: winner, loser: loser],
        where: winner.id == ^id or loser.id == ^id

    Repo.all(query)
  end

  def list_games_for_deck_interval(faction, agenda, days) do
    if agenda do
      query =
        from game in Game,
          where:
            game.tournament_date > ago(^days, "day") and
              ((game.winner_faction == ^faction and game.winner_agenda == ^agenda) or
                 (game.loser_faction == ^faction and game.loser_agenda == ^agenda))

      Repo.all(query)
    else
      []
    end
  end

  def list_incomplete do
    Repo.all(Incomplete)
  end

  def list_incomplete_for_tournament(id) do
    query =
      from incomplete in Incomplete,
        where: incomplete.tournament_id == ^id

    Repo.all(query)
  end

  def list_last_interval(days) do
    query =
      from game in Game,
        where: game.tournament_date > ago(^days, "day")

    Repo.all(query)
  end

  def create_game(attrs, winner_id, loser_id) do
    winner = Players.get_winner(winner_id)
    loser = Players.get_loser(loser_id)

    %Game{}
    |> Game.changeset(attrs, winner, loser)
    |> Repo.insert()
  end

  def create_incomplete_game(attrs) do
    %Incomplete{}
    |> Incomplete.changeset(attrs)
    |> Repo.insert()
  end

  def delete_incomplete_tournament(id) do
    query =
      from incomplete in Incomplete,
        where: incomplete.tournament_id == ^id

    Repo.delete_all(query)
  end

  def delete_incomplete_game(id) do
    query = from incomplete in Incomplete, where: incomplete.id == ^id

    Repo.one(query)
    |> Repo.delete()
  end

  def list_games_with_agendas do
    query =
      from game in Game,
        where: is_nil(game.winner_agenda) == false and is_nil(game.loser_agenda) == false

    Repo.all(query)
  end
end
