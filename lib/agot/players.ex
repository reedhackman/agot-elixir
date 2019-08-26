defmodule Agot.Players do
  alias Agot.Repo
  alias Agot.Players.Player

  import Ecto.Query

  def list_players do
    Repo.all(Player)
  end

  def top_ten_players do
    query =
      from player in Player,
        order_by: [desc: player.rating],
        limit: 10

    Repo.all(query)
  end

  def list_names_for_ids(ids) do
    query =
      from player in Player,
        where: player.id in ^ids,
        select: {player.name, player.id}

    Repo.all(query)
  end

  def list_players_advanced(name, strict, min) do
    min_games =
      if min === "" do
        0
      else
        String.to_integer(min)
      end

    query =
      if strict === "true" do
        from player in Player,
          where:
            player.played >= ^min_games and
              like(player.name, ^"%#{String.replace(name, "%", "\\%")}%")
      else
        from player in Player,
          where:
            player.played >= ^min_games and
              ilike(player.name, ^"%#{String.replace(name, "%", "\\%")}%")
      end

    Repo.all(query)
  end

  def sort_players_by(players, sort, asc) do
    cond do
      sort === "name" ->
        players

      sort === "rating" ->
        sort_players_by_rating(players, asc)

      sort === "percent" ->
        sort_players_by_percent(players, asc)

      sort === "played" ->
        sort_players_by_played(players, asc)
    end
  end

  def sort_players_by_name(players, asc) do
    name_sort =
      if asc === "true" do
        &(&1.name <= &2.name)
      else
        &(&1.name >= &2.name)
      end

    Enum.sort(players, name_sort)
  end

  def sort_players_by_rating(players, asc) do
    rating_sort =
      if asc === "true" do
        &(&1.rating >= &2.rating)
      else
        &(&1.rating <= &2.rating)
      end

    Enum.sort(players, rating_sort)
  end

  def sort_players_by_played(players, asc) do
    played_sort =
      if asc === "true" do
        &(&1.played >= &2.played)
      else
        &(&1.played <= &2.played)
      end

    Enum.sort(players, played_sort)
  end

  def sort_players_by_percent(players, asc) do
    percent_sort =
      if asc === "true" do
        &(&1.percent >= &2.percent)
      else
        &(&1.percent <= &2.percent)
      end

    Enum.sort(players, percent_sort)
  end

  def get_player(id) do
    Repo.one(from player in Player, where: player.id == ^id)
  end

  def get_player_and_tournaments(id) do
    query =
      from player in Player,
        where: player.id == ^id,
        left_join: tournaments in assoc(player, :tournaments),
        preload: [tournaments: tournaments]

    Repo.one(query)
  end

  def get_player(id, name) do
    case Repo.one(from player in Player, where: player.id == ^id) do
      nil ->
        create_player(id, name)

      player ->
        player
    end
  end

  def get_winner(id) do
    query =
      from player in Player,
        where: player.id == ^id,
        left_join: wins in assoc(player, :wins),
        preload: [wins: wins]

    Repo.one(query)
  end

  def get_loser(id) do
    query =
      from player in Player,
        where: player.id == ^id,
        left_join: losses in assoc(player, :losses),
        preload: [losses: losses]

    Repo.one(query)
  end

  def create_player(id, name) do
    attrs = %{name: name, id: id, num_wins: 0, num_losses: 0, rating: 1200}

    %Player{}
    |> Player.create_changeset(attrs)
    |> Repo.insert()
    |> Kernel.elem(1)
  end

  def update_player(id, attrs) do
    Repo.one(from p in Player, where: p.id == ^id)
    |> Player.update_changeset(attrs)
    |> Repo.update()
  end
end
