defmodule Agot.Tests do
  alias Agot.Cache
  alias Agot.Players
  alias Agot.Games

  def process_all_games do
    data = Poison.decode!(File.read!("./tjp"))
    Enum.each(data, fn x -> clean_and_process_game(x) end)
    update_all_players()
  end

  def update_all_players do
    :ets.match(:updated_players_cache, {:"_", :"$2"})
    |> List.flatten()
    |> Enum.each(fn x -> update_player(x) end)
  end

  def update_player(attrs) do
    Players.update_player(attrs.player_id, attrs)
    Cache.put_player(attrs.player_id, attrs)
    Cache.delete_updated_player(attrs.player_id)
  end

  def clean_and_process_game(game) do
    temp =
      strings_to_atoms(game)
      |> check_game()
    cond do
      temp === nil -> nil
      true -> process_game(temp)
    end
  end

  def strings_to_atoms(attrs) do
    %{
      game_status: attrs["game_status"],
      p1_points: attrs["p1_points"],
      p2_points: attrs["p2_points"],
      p1_id: attrs["p1_id"],
      p2_id: attrs["p2_id"],
      p1_name: attrs["p1_name"],
      p2_name: attrs["p2_name"],
      p1_faction: attrs["p1_faction"],
      p1_agenda: attrs["p1_agenda"],
      p2_faction: attrs["p2_faction"],
      p2_agenda: attrs["p2_agenda"],
      tournament_id: attrs["tournament_id"],
      tournament_date: attrs["tournament_date"],
      game_id: attrs["game_id"]
    }
  end

  def check_game(game) do
    cond do
      game.game_status !== 100 ->
        Games.create_incomplete_game(%{tournament_id: game.tournament_id, game_id: game.game_id})
        nil

      game.p1_id < 1 or game.p2_id < 1 ->
        nil

      game.p1_points > game.p2_points ->
        game =
          %{
            winner: %{
              id: game.p1_id,
              name: game.p1_name,
              faction: game.p1_faction,
              agenda: game.p1_agenda
            },
            loser: %{
              id: game.p2_id,
              name: game.p2_name,
              faction: game.p2_faction,
              agenda: game.p2_agenda
            },
            misc: %{
              game_id: game.game_id,
              tournament_id: game.tournament_id,
              tournament_date: game.tournament_date
            }
          }

      game.p2_points > game.p1_points ->
        game =
          %{
            loser: %{
              id: game.p1_id,
              name: game.p1_name,
              faction: game.p1_faction,
              agenda: game.p1_agenda
            },
            winner: %{
              id: game.p2_id,
              name: game.p2_name,
              faction: game.p2_faction,
              agenda: game.p2_agenda
            },
            misc: %{
              game_id: game.game_id,
              tournament_id: game.tournament_id,
              tournament_date: game.tournament_date
            }
          }

      game.p1_points === game.p2_points ->
        nil
    end
  end

  def process_game(game) do
    winner =
      case Cache.get_updated_player(game.winner.id) do
        nil ->
          get_player(game.winner.id, game.winner.name)
        player ->
          player
      end
    loser =
      case Cache.get_updated_player(game.loser.id) do
        nil ->
          get_player(game.loser.id, game.loser.name)
        player ->
          player
      end
    Games.create_game(%{
        winner_faction: game.winner.faction,
        winner_agenda: game.winner.agenda,
        loser_faction: game.loser.faction,
        loser_agenda: game.loser.agenda,
        tournament_id: game.misc.tournament_id,
        game_id: game.misc.game_id,
        tournament_date: game.misc.tournament_date
      }, game.winner.id, game.loser.id)
    rate(winner, loser)
  end

  def rate(winner, loser) do
    k = 40
    e_w = 1 / (1 + :math.pow(10, (loser.rating - winner.rating) / 400))
    e_l = 1 / (1 + :math.pow(10, (winner.rating - loser.rating) / 400))
    r_w = winner.rating + k * (1 - e_w)
    r_l = loser.rating + k * (0 - e_l)
    Cache.put_updated_player(winner.player_id, %{player_id: winner.player_id, name: winner.name, num_wins: winner.num_wins + 1, num_losses: winner.num_losses, rating: r_w})
    Cache.put_updated_player(loser.player_id, %{player_id: loser.player_id, name: loser.name, num_wins: loser.num_wins, num_losses: loser.num_losses + 1, rating: r_l})
  end

  def get_player(id, name) do
    case Cache.get_player(id) do
      nil ->
        player = Players.get_player(id, name)
        Cache.put_updated_player(id, player)
        player
      player ->
        Cache.put_updated_player(id, player)
        player
    end
  end
end
