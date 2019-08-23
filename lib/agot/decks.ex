defmodule Agot.Decks do
  alias Agot.Decks.Deck
  alias Agot.Repo
  alias Agot.Cache
  alias Agot.Games.Game
  alias Agot.Decks.Matchup

  import Ecto.Query

  def create_deck(faction, agenda) do
    attrs = %{faction: faction, agenda: agenda, num_wins: 0, num_losses: 0}

    deck =
      %Deck{}
      |> Deck.create_changeset(attrs)
      |> Repo.insert()
      |> Kernel.elem(1)

    Cache.put_deck({faction, agenda}, %{
      faction: faction,
      agenda: agenda,
      num_wins: 0,
      num_losses: 0,
      id: deck.id
    })

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
        Cache.put_deck({faction, agenda}, %{
          faction: deck.faction,
          agenda: deck.agenda,
          num_wins: deck.num_wins,
          num_losses: deck.num_losses,
          id: deck.id
        })

        deck
    end
  end

  def list_decks do
    Repo.all(Deck)
  end

  def top_ten_quarter do
    query =
      from deck in Deck,
        where: deck.last_ninety_played >= 30,
        order_by: [desc: deck.last_ninety_percent],
        limit: 10

    Repo.all(query)
  end

  def top_five_faction(faction) do
    query =
      from deck in Deck,
        where: deck.faction == ^faction and deck.last_ninety_played > 30,
        order_by: [desc: deck.last_ninety_percent],
        limit: 5

    Repo.all(query)
  end

  def list_decks_for_faction(faction) do
    query =
      from deck in Deck,
        where: deck.faction == ^faction,
        order_by: [desc: deck.last_ninety_percent]

    Repo.all(query)
  end

  def list_decks_for_faction(faction, sort, order) do
    order_by =
      cond do
        sort === "agenda" and order === "asc" -> [asc: :agenda]
        sort === "agenda" and order === "desc" -> [desc: :agenda]
        sort === "percent" and order === "asc" -> [asc: :last_ninety_percent]
        sort === "percent" and order === "desc" -> [desc: :last_ninety_percent]
        sort === "played" and order === "asc" -> [asc: :last_ninety_played]
        sort === "played" and order === "desc" -> [desc: :last_ninety_played]
      end

    query =
      from deck in Deck,
        where: deck.faction == ^faction,
        order_by: ^order_by

    Repo.all(query)
  end

  def list_matchups_for_deck(faction, agenda) do
    query =
      from matchup in Matchup,
        where: matchup.faction == ^faction and matchup.agenda == ^agenda

    Repo.all(query)
  end

  def get_games_for_deck(faction, agenda) do
    query =
      if agenda == nil do
        from game in Game,
          where:
            (game.winner_faction == ^faction and is_nil(game.winner_agenda)) or
              (game.loser_faction == ^faction and is_nil(game.loser_agenda))
      else
        from game in Game,
          where:
            (game.winner_faction == ^faction and game.winner_agenda == ^agenda) or
              (game.loser_faction == ^faction and game.loser_agenda == ^agenda)
      end

    Repo.all(query)
  end

  def update_deck_by_id(deck_id, attrs) do
    Repo.one(from deck in Deck, where: deck.id == ^deck_id)
    |> Deck.update_changeset(attrs)
    |> Repo.update()
  end

  def update_ninety(deck, attrs) do
    deck
    |> Deck.ninety_changeset(attrs)
    |> Repo.update()
  end
end
