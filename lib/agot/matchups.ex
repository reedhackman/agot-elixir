defmodule Agot.Matchups do
  alias Agot.Repo
  alias Agot.Cache
  alias Agot.Decks.Matchup
  alias Agot.Games.Game

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

  def get_games_for_matchup(faction, agenda, oppfaction, oppagenda) do
    query =
      cond do
        agenda == nil and oppagenda == nil ->
          from game in Game,
          where: (game.winner_faction == ^faction and is_nil(game.winner_agenda) and game.loser_faction == ^oppfaction and is_nil(game.loser_agenda)) or (game.loser_faction == ^faction and is_nil(game.loser_agenda) and game.winner_faction == ^oppfaction and is_nil(game.winner_agenda))

        agenda == nil ->
          from game in Game,
          where: (game.winner_faction == ^faction and is_nil(game.winner_agenda) and game.loser_faction == ^oppfaction and game.loser_agenda == ^oppagenda) or (game.loser_faction == ^faction and game.loser_agenda == ^agenda and game.winner_faction == ^oppfaction and is_nil(game.winner_agenda))

        oppagenda == nil ->
          from game in Game,
          where: (game.winner_faction == ^faction and game.winner_agenda == ^agenda and game.loser_faction == ^oppfaction and is_nil(game.loser_agenda)) or (game.loser_faction == ^faction and is_nil(game.loser_agenda) and game.winner_faction == ^oppfaction and game.winner_agenda == ^oppagenda)

        true ->
          from game in Game,
          where: (game.winner_faction == ^faction and game.winner_agenda == ^agenda and game.loser_faction == ^oppfaction and game.loser_agenda == ^oppagenda) or (game.loser_faction == ^faction and game.loser_agenda == ^agenda and game.winner_faction == ^oppfaction and game.winner_agenda == ^oppagenda)
      end
    Repo.all(query)
  end

  def get_matchup(faction, agenda, oppfaction, oppagenda) do
    query =
      cond do
        agenda == nil and oppagenda == nil ->
          from matchup in Matchup,
          where: matchup.faction == ^faction and is_nil(matchup.agenda) and matchup.oppfaction == ^oppfaction and is_nil(matchup.oppagenda)

        agenda == nil ->
          from matchup in Matchup,
          where: matchup.faction == ^faction and is_nil(matchup.agenda) and matchup.oppfaction == ^oppfaction and matchup.oppagenda == ^oppagenda

        oppagenda == nil ->
          from matchup in Matchup,
          where: matchup.faction == ^faction and matchup.agenda == ^agenda and matchup.oppfaction == ^oppfaction and is_nil(matchup.oppagenda)

        true ->
          from matchup in Matchup,
          where: matchup.faction == ^faction and matchup.agenda == ^agenda and matchup.oppfaction == ^oppfaction and matchup.oppagenda == ^oppagenda
      end
    case Repo.one(query) do
      nil ->
        create_matchup(faction, agenda, oppfaction, oppagenda)
      matchup ->
        Cache.put_matchup({faction, agenda, oppfaction, oppagenda}, matchup)
        matchup
    end
  end

  def update_matchup_by_id(matchup_id, attrs) do
    Repo.one(from matchup in Matchup, where: matchup.id == ^matchup_id)
    |> Matchup.changeset(attrs)
    |> Repo.update()
  end
end
