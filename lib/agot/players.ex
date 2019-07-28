defmodule Agot.Players do
  alias Agot.Repo
  alias Agot.Cache
  alias Agot.Players.Player

  import Ecto.Query

  def list_players do
    Repo.all(Player)
  end

  def get_player(id) do
    Repo.one(from player in Player, where: player.id == ^id)
  end


  def get_player(id, name) do
    case Repo.one(from player in Player, where: player.id == ^id) do
      nil ->
        create_player(id, name)
      player ->
        Cache.put_player(id, player)
        player
    end
  end

  def get_winner(id) do
    query =
      from player in Player, where: player.id == ^id,
      left_join: wins in assoc(player, :wins),
      preload: [wins: wins]
    Repo.one(query)
  end

  def get_loser(id) do
    query =
      from player in Player, where: player.id == ^id,
      left_join: losses in assoc(player, :losses),
      preload: [losses: losses]
    Repo.one(query)
  end

  def create_player(id, name) do
    attrs = %{name: name, id: id, num_wins: 0, num_losses: 0, rating: 1200}
    Cache.put_player(id, attrs)
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
    |> Kernel.elem(1)
  end

  def update_player(id, attrs) do
    Repo.one(from p in Player, where: p.id == ^id)
    |> Player.changeset(attrs)
    |> Repo.update()
  end
end
