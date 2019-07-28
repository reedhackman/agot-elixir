defmodule Agot.Games do
  alias Agot.Repo
  alias Agot.Games.Game
  alias Agot.Games.Incomplete
  alias Agot.Players

  import Ecto.Query

  def list_games_for_player(player_id) do
    query =
      from game in Game,
      left_join: winner in assoc(game, :winner),
      left_join: loser in assoc(game, :loser),
      preload: [winner: winner, loser: loser],
      where: winner.player_id == ^player_id or loser.player_id == ^player_id
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
end
