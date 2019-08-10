defmodule Agot.Analytica do
  alias Agot.Cache
  alias Agot.Players
  alias Agot.Games
  alias Agot.Matchups
  alias Agot.Decks
  alias Agot.Misc

  def process_from_test(data) do
    Enum.each(data, fn x -> check_for_illegal(x) end)
    exclude_map =
      :ets.match(:exclude_cache, {:"_", :"$2"})
      |> List.flatten()
    exclude_list =
      exclude_map
      |> Enum.map(fn x -> x.tournament_id end)
    Enum.each(data, fn x -> clean_and_process_game(x, exclude_list) end)
    update_all_players()
    update_all_decks()
    update_all_matchups()
  end

  def process_from_file do
    data = Poison.decode!(File.read!("./tjp"))
    Enum.each(data, fn x -> check_for_illegal(x) end)
    exclude_map =
      :ets.match(:exclude_cache, {:"_", :"$2"})
      |> List.flatten()
    exclude_list =
      exclude_map
      |> Enum.map(fn x -> x.tournament_id end)
    Enum.each(data, fn x -> clean_and_process_game(x, exclude_list) end)
    update_all_players()
    update_all_decks()
    update_all_matchups()
  end

  def process_all_games(data, page_number, page_length) do
    Enum.each(data, fn x -> check_for_illegal(x) end)
    exclude_map =
      :ets.match(:exclude_cache, {:"_", :"$2"})
      |> List.flatten()
    exclude_list =
      exclude_map
      |> Enum.map(fn x -> x.tournament_id end)
    Enum.each(data, fn x -> clean_and_process_game(x, exclude_list) end)
    update_all_players()
    update_all_decks()
    update_all_matchups()
    update_position(%{page_number: page_number, page_length: page_length})
  end

  def update_all_players do
    :ets.match(:updated_players_cache, {:"_", :"$2"})
    |> List.flatten()
    |> Enum.each(fn x -> update_player(x) end)
  end

  def update_all_decks do
    :ets.match(:updated_decks_cache, {:"1", :"$2"})
    |> List.flatten()
    |> Enum.each(fn x -> update_deck_by_id(List.first(x), List.last(x)) end)
  end

  def update_all_matchups do
    :ets.match(:updated_matchups_cache, {:"1", :"$2"})
    |> List.flatten()
    |> Enum.each(fn x -> update_matchup_by_id(List.first(x), List.last(x)) end)
  end

  def update_player(attrs) do
    Players.update_player(attrs.id, attrs)
    Cache.put_player(attrs.id, attrs)
    Cache.delete_updated_player(attrs.id)
  end

  def update_deck_by_id(deck_tuple, attrs) do
    Decks.update_deck_by_id(attrs.id, attrs)
    Cache.put_deck(deck_tuple, attrs)
    Cache.delete_updated_deck(deck_tuple)
  end

  def update_matchup_by_id(matchup_tuple, attrs) do
    Matchups.update_matchup_by_id(attrs.id, attrs)
    Cache.put_matchup(matchup_tuple, attrs)
    Cache.delete_updated_matchup(matchup_tuple)
  end

  def update_position(attrs) do
    Misc.update_position(attrs)
  end

  def clean_and_process_game(game, exclude_list) do
    if Enum.member?(exclude_list, game["tournament_id"]) do
      nil
    else
      temp =
        strings_to_atoms(game)
        |> check_game()
      cond do
        temp === nil -> nil
        true -> process_game(temp)
      end
    end
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
    cond do
      attrs["p1_agenda"] == nil and attrs["p2_agenda"] == nil ->
        %{
          game_status: attrs["game_status"],
          p1_points: attrs["p1_points"],
          p2_points: attrs["p2_points"],
          p1_id: attrs["p1_id"],
          p2_id: attrs["p2_id"],
          p1_name: attrs["p1_name"],
          p2_name: attrs["p2_name"],
          p1_faction: attrs["p1_faction"],
          p1_agenda: "",
          p2_faction: attrs["p2_faction"],
          p2_agenda: "",
          tournament_id: attrs["tournament_id"],
          tournament_date: attrs["tournament_date"],
          game_id: attrs["game_id"],
        }

      attrs["p1_agenda"] == nil ->
        %{
          game_status: attrs["game_status"],
          p1_points: attrs["p1_points"],
          p2_points: attrs["p2_points"],
          p1_id: attrs["p1_id"],
          p2_id: attrs["p2_id"],
          p1_name: attrs["p1_name"],
          p2_name: attrs["p2_name"],
          p1_faction: attrs["p1_faction"],
          p1_agenda: "",
          p2_faction: attrs["p2_faction"],
          p2_agenda: attrs["p2_agenda"],
          tournament_id: attrs["tournament_id"],
          tournament_date: attrs["tournament_date"],
          game_id: attrs["game_id"]
        }

      attrs["p2_agenda"] == nil ->
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
          p2_agenda: "",
          tournament_id: attrs["tournament_id"],
          tournament_date: attrs["tournament_date"],
          game_id: attrs["game_id"]
        }

      true ->
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
  end

  def check_game(game) do
    cond do
      game.game_status !== 100 ->
        Games.create_incomplete_game(%{tournament_id: game.tournament_id, id: game.game_id})
        nil

      game.p1_id < 1 or game.p2_id < 1 ->
        nil

      game.p1_points > game.p2_points ->
        _game =
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
              id: game.game_id,
              tournament_id: game.tournament_id,
              tournament_date: game.tournament_date
            }
          }

      game.p2_points > game.p1_points ->
        _game =
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
              id: game.game_id,
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
        id: game.misc.id,
        tournament_date: game.misc.tournament_date
      }, game.winner.id, game.loser.id)
    rate(winner, loser)
    process_decks(game.winner.faction, game.winner.agenda, game.loser.faction, game.loser.agenda)
  end

  def process_decks(winner_faction, winner_agenda, loser_faction, loser_agenda) do
    if winner_faction == loser_faction and winner_agenda == loser_agenda do
      nil
    else
      cond do
        winner_faction != nil and loser_faction != nil ->
          winner_matchup =
            case Cache.get_updated_matchup({winner_faction, winner_agenda, loser_faction, loser_agenda}) do
              nil ->
                get_matchup(winner_faction, winner_agenda, loser_faction, loser_agenda)
              matchup ->
                matchup
            end
          loser_matchup =
            case Cache.get_updated_matchup({loser_faction, loser_agenda, winner_faction, winner_agenda}) do
              nil ->
                get_matchup(loser_faction, loser_agenda, winner_faction, winner_agenda)
              matchup ->
                matchup
            end
          winner_deck =
            case Cache.get_updated_deck({winner_faction, winner_agenda}) do
              nil ->
                get_deck(winner_faction, winner_agenda)
              deck ->
                deck
              end
          loser_deck =
            case Cache.get_updated_deck({loser_faction, loser_agenda}) do
              nil ->
                get_deck(loser_faction, loser_agenda)
              deck ->
                deck
              end
          process_matchup(winner_matchup, loser_matchup)
          process_decks(winner_deck, loser_deck)

        winner_agenda === "The Free Folk" and loser_faction != nil ->
          winner_matchup =
            case Cache.get_updated_matchup({winner_agenda, winner_agenda, loser_faction, loser_agenda}) do
              nil ->
                get_matchup(winner_agenda, winner_agenda, loser_faction, loser_agenda)
              matchup ->
                matchup
            end
          loser_matchup =
            case Cache.get_updated_matchup({loser_faction, loser_agenda, winner_agenda, winner_agenda}) do
              nil ->
                get_matchup(loser_faction, loser_agenda, winner_agenda, winner_agenda)
              matchup ->
                matchup
            end
          winner_deck =
            case Cache.get_updated_deck({winner_agenda, winner_agenda}) do
              nil ->
                get_deck(winner_agenda, winner_agenda)
              deck ->
                deck
              end
          loser_deck =
            case Cache.get_updated_deck({loser_faction, loser_agenda}) do
              nil ->
                get_deck(loser_faction, loser_agenda)
              deck ->
                deck
              end
          process_matchup(winner_matchup, loser_matchup)
          process_decks(winner_deck, loser_deck)

        winner_faction != nil and loser_agenda === "The Free Folk" ->
          winner_matchup =
            case Cache.get_updated_matchup({winner_faction, winner_agenda, loser_agenda, loser_agenda}) do
              nil ->
                get_matchup(winner_faction, winner_agenda, loser_agenda, loser_agenda)
              matchup ->
                matchup
            end
          loser_matchup =
            case Cache.get_updated_matchup({loser_agenda, loser_agenda, winner_faction, winner_agenda}) do
              nil ->
                get_matchup(loser_agenda, loser_agenda, winner_faction, winner_agenda)
              matchup ->
                matchup
            end
          winner_deck =
            case Cache.get_updated_deck({winner_faction, winner_agenda}) do
              nil ->
                get_deck(winner_faction, winner_agenda)
              deck ->
                deck
              end
          loser_deck =
            case Cache.get_updated_deck({loser_agenda, loser_agenda}) do
              nil ->
                get_deck(loser_agenda, loser_agenda)
              deck ->
                deck
              end
          process_matchup(winner_matchup, loser_matchup)
          process_decks(winner_deck, loser_deck)

        winner_agenda === "The Free Folk" and loser_agenda === "The Free Folk" ->
          winner_matchup =
            case Cache.get_updated_matchup({winner_agenda, winner_agenda, loser_agenda, loser_agenda}) do
              nil ->
                get_matchup(winner_agenda, winner_agenda, loser_agenda, loser_agenda)
              matchup ->
                matchup
            end
          loser_matchup =
            case Cache.get_updated_matchup({loser_agenda, loser_agenda, winner_agenda, winner_agenda}) do
              nil ->
                get_matchup(loser_agenda, loser_agenda, winner_agenda, winner_agenda)
              matchup ->
                matchup
            end
          winner_deck =
            case Cache.get_updated_deck({winner_agenda, winner_agenda}) do
              nil ->
                get_deck(winner_agenda, winner_agenda)
              deck ->
                deck
              end
          loser_deck =
            case Cache.get_updated_deck({loser_agenda, loser_agenda}) do
              nil ->
                get_deck(loser_agenda, loser_agenda)
              deck ->
                deck
              end
          process_matchup(winner_matchup, loser_matchup)
          process_decks(winner_deck, loser_deck)

        true -> nil
      end
    end
  end

  def process_matchup(winner_matchup, loser_matchup) do
    Cache.put_updated_matchup({winner_matchup.faction, winner_matchup.agenda, loser_matchup.faction, loser_matchup.agenda}, %{id: winner_matchup.id, num_wins: winner_matchup.num_wins + 1, num_losses: winner_matchup.num_losses})
    Cache.put_updated_matchup({loser_matchup.faction, loser_matchup.agenda, winner_matchup.faction, winner_matchup.agenda}, %{id: loser_matchup.id, num_wins: loser_matchup.num_wins, num_losses: loser_matchup.num_losses + 1})
  end

  def process_decks(winner_deck, loser_deck) do
    Cache.put_updated_deck({winner_deck.faction, winner_deck.agenda}, %{id: winner_deck.id, num_wins: winner_deck.num_wins + 1, num_losses: winner_deck.num_losses})
    Cache.put_updated_deck({loser_deck.faction, loser_deck.agenda}, %{id: loser_deck.id, num_wins: loser_deck.num_wins, num_losses: loser_deck.num_losses + 1})
  end

  def rate(winner, loser) do
    k = 40
    e_w = 1 / (1 + :math.pow(10, (loser.rating - winner.rating) / 400))
    e_l = 1 / (1 + :math.pow(10, (winner.rating - loser.rating) / 400))
    r_w = winner.rating + k * (1 - e_w)
    r_l = loser.rating + k * (0 - e_l)
    Cache.put_updated_player(winner.id, %{id: winner.id, num_wins: winner.num_wins + 1, num_losses: winner.num_losses, rating: r_w})
    Cache.put_updated_player(loser.id, %{id: loser.id, num_wins: loser.num_wins, num_losses: loser.num_losses + 1, rating: r_l})
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

  def get_deck(faction, agenda) do
    case Cache.get_deck({faction, agenda}) do
      nil ->
        deck = Decks.get_deck(faction, agenda)
        Cache.put_updated_deck({faction, agenda}, %{id: deck.id, faction: deck.faction, agenda: deck.agenda, num_wins: deck.num_wins, num_losses: deck.num_losses})
        deck
      deck ->
        Cache.put_updated_deck({faction, agenda}, %{id: deck.id, faction: deck.faction, agenda: deck.agenda, num_wins: deck.num_wins, num_losses: deck.num_losses})
        deck
    end
  end

  def get_matchup(faction, agenda, oppfaction, oppagenda) do
    case Cache.get_matchup({faction, agenda, oppfaction, oppagenda}) do
      nil ->
        matchup = Matchups.get_matchup(faction, agenda, oppfaction, oppagenda)
        Cache.put_updated_matchup({faction, agenda, oppfaction, oppagenda}, %{id: matchup.id, faction: matchup.faction, agenda: matchup.agenda, oppfaction: matchup.oppfaction, oppagenda: matchup.oppagenda, num_wins: matchup.num_wins, num_losses: matchup.num_losses})
        matchup
      matchup ->
        Cache.put_updated_matchup({faction, agenda, oppfaction, oppagenda}, %{id: matchup.id, faction: matchup.faction, agenda: matchup.agenda, oppfaction: matchup.oppfaction, oppagenda: matchup.oppagenda, num_wins: matchup.num_wins, num_losses: matchup.num_losses})
        matchup
    end
  end

  def check_for_illegal(game) do
    name = game["tournament_name"]
    id = game["tournament_id"]
    cond do
      Regex.match?(~r/l5r/i, name) ->
        Cache.put_exclude(id, %{tournament_name: name, tournament_id: id})
      Regex.match?(~r/destiny/i, name) ->
        Cache.put_exclude(id, %{tournament_name: name, tournament_id: id})
      Regex.match?(~r/draft/i, name) ->
        Cache.put_exclude(id, %{tournament_name: name, tournament_id: id})
      game["p1_agenda"] == "Uniting the Seven Kingdoms" ->
        Cache.put_exclude(id, %{tournament_name: name, tournament_id: id})
      game["p1_agenda"] == "Treaty" ->
        Cache.put_exclude(id, %{tournament_name: name, tournament_id: id})
      game["p1_agenda"] == "Protectors of the Realm" ->
        Cache.put_exclude(id, %{tournament_name: name, tournament_id: id})
      game["p1_agenda"] == "The Power of Wealth" ->
        Cache.put_exclude(id, %{tournament_name: name, tournament_id: id})
      game["p2_agenda"] == "Uniting the Seven Kingdoms" ->
        Cache.put_exclude(id, %{tournament_name: name, tournament_id: id})
      game["p2_agenda"] == "Treaty" ->
        Cache.put_exclude(id, %{tournament_name: name, tournament_id: id})
      game["p2_agenda"] == "Protectors of the Realm" ->
        Cache.put_exclude(id, %{tournament_name: name, tournament_id: id})
      game["p2_agenda"] == "The Power of Wealth" ->
        Cache.put_exclude(id, %{tournament_name: name, tournament_id: id})
      true ->
        nil
    end
  end
end