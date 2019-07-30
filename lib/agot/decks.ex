defmodule Agot.Decks do
  alias Agot.Decks.Deck
  alias Agot.Repo
  alias Agot.Cache
  alias Agot.Games.Game

  import Ecto.Query

  def create_deck(faction, agenda) do
    attrs = %{faction: faction, agenda: agenda, wins: 0, losses: 0}
    deck =
      %Deck{}
      |> Deck.changeset(attrs)
      |> Repo.insert()
      |> Kernel.elem(1)
    Cache.put_deck({faction, agenda}, %{faction: faction, agenda: agenda, wins: 0, losses: 0, id: deck.id})
    deck
  end

  def get_deck(faction, agenda) do
    query =
      if agenda == nil do
        from deck in Deck,
        where: deck.faction == ^faction and is_nil(deck.agenda)
      else
        from deck in Deck,
        where: deck.faction == ^faction and deck.agenda == ^agenda
      end
    case Repo.one(query) do
      nil ->
        create_deck(faction, agenda)
      deck ->
        Cache.put_deck({faction, agenda}, %{faction: deck.faction, agenda: deck.agenda, wins: deck.wins, losses: deck.losses, id: deck.id})
        deck
    end
  end

  def get_games_for_deck(faction, agenda) do
    query =
      if agenda == nil do
        from game in Game,
        where: (game.winner_faction == ^faction and is_nil(game.winner_agenda)) or (game.loser_faction == ^faction and is_nil(game.loser_agenda))
      else
        from game in Game,
        where: (game.winner_faction == ^faction and game.winner_agenda == ^agenda) or (game.loser_faction == ^faction and game.loser_agenda == ^agenda)
      end
    Repo.all(query)
  end

  def update_deck_by_id(deck_id, attrs) do
    Repo.one(from deck in Deck, where: deck.id == ^deck_id)
    |> Deck.changeset(attrs)
    |> Repo.update()
  end
end
