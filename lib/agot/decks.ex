defmodule Agot.Decks do
  alias Agot.Decks.Deck
  alias Agot.Repo
  alias Agot.Cache

  import Ecto.Query

  def create_deck(faction, agenda) do
    attrs = %{faction: faction, agenda: agenda, wins: 0, losses: 0}
    Cache.put_deck(faction <> agenda, attrs)
    %Deck{}
    |> Deck.changeset(attrs)
    |> Repo.insert()
    |> Kernel.elem(1)
  end

  def get_deck(faction, agenda) do
    query =
      from deck in Deck,
      where: deck.faction == ^faction and deck.agenda == ^agenda
    case Repo.one(query) do
      nil ->
        create_deck(faction, agenda)
      deck ->
        Cache.put_deck(faction <> agenda, deck)
        deck
    end
  end

  def update_deck(faction, agenda, attrs) do
    Repo.one(from deck in Deck, where: deck.faction == ^faction and deck.agenda == ^agenda)
    |> Deck.changeset(attrs)
    |> Repo.update()
  end
end
