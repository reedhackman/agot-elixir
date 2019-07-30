defmodule Agot.Matchups do
  alias Agot.Repo
  alias Agot.Cache
  alias Agot.Decks.Matchup

  import Ecto.Query

  def create_matchup(faction, agenda, oppfaction, oppagenda) do
    attrs = %{faction: faction, agenda: agenda, oppfaction: oppfaction, oppagenda: oppagenda, wins: 0, losses: 0}
    matchup =
      %Matchup{}
      |> Matchup.changeset(attrs)
      |> Repo.insert()
      |> Kernel.elem(1)
    Cache.put_matchup({faction, agenda, oppfaction, oppagenda}, matchup)
    matchup
  end

  def get_matchup(faction, agenda, oppfaction, oppagenda) do
    query =
      from matchup in Matchup,
      where: matchup.faction == ^faction and matchup.agenda == ^agenda and matchup.oppfaction == ^oppfaction and matchup.oppagenda == ^oppagenda
    case Repo.one(query) do
      nil ->
        create_matchup(faction, agenda, oppfaction, oppagenda)
      matchup ->
        Cache.put_matchup({faction, agenda, oppfaction, oppagenda}, matchup)
        matchup
    end
  end

  def update_matchup(matchup_id, attrs) do
    Repo.one(from matchup in Matchup, where: matchup.id == ^matchup_id)
    |> Matchup.changeset(attrs)
    |> Repo.update()
  end
end
