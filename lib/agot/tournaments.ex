defmodule Agot.Tournaments do
  alias Agot.Tournaments.Tournament
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

  def get_tournament(id, name) do
    case Repo.one(from tournament in Tournament, where: tournament.id == ^id) do
      nil ->
        create_tournament(id, name)

      tournament ->
        Cache.put_tournament(id, tournament)
        tournament
    end
  end

  def update_tournament(id, attrs) do
    Repo.one(from t in Tournament, where: t.id == ^id)
    |> Tournament.changeset(attrs)
    |> Repo.update()
  end

  def list_missing_placements do
    query =
      from t in Tournament,
        where: is_nil(t.player_placements)

    Repo.all(query)
  end
end
