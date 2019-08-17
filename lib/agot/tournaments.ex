defmodule Agot.Tournaments do
  alias Agot.Tournaments.Tournament
  alias Agot.Players
  alias Agot.Repo
  alias Agot.Cache
  import Ecto.Query

  def create_tournament(id, name) do
    attrs = %{tournament_name: name, id: id}

    %Tournament{}
    |> Tournament.changeset(attrs)
    |> Repo.insert()
    |> Kernel.elem(1)
  end

  def get_tournament(id) do
    Repo.one(from tournament in Tournament, where: tournament.id == ^id)
  end

  def get_tournament_and_players(id) do
    query =
      from tournament in Tournament,
        where: tournament.id == ^id,
        left_join: players in assoc(tournament, :players),
        preload: [players: players]

    Repo.one(query)
  end

  def get_tournament(id, name) do
    case Repo.one(from tournament in Tournament, where: tournament.id == ^id) do
      nil ->
        create_tournament(id, name)

      tournament ->
        Cache.put_tournament(id, tournament)
        tournament
    end
  end

  def update_tournament(%Tournament{} = tournament, attrs) do
    tournament
    |> Tournament.changeset(attrs)
    |> Repo.update()
  end

  def add_player_to_tournament(%Tournament{} = tournament, player_id) do
    player = Players.get_player_and_tournaments(player_id)

    tournament
    |> Tournament.player_changeset(player)
    |> Repo.update()
  end

  def list_missing_placements do
    query =
      from tournament in Tournament,
        where: is_nil(tournament.player_placements),
        left_join: players in assoc(tournament, :players),
        preload: [players: players]

    Repo.all(query)
  end
end
