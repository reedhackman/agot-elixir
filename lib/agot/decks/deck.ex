defmodule Agot.Decks.Deck do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :faction,
    :agenda,
    :num_wins,
    :num_losses
  ]

  @required_fields [
    :faction
  ]

  @ninety [
    :last_ninety_played,
    :last_ninety_percent
  ]

  schema "decks" do
    field :faction, :string
    field :agenda, :string
    field :num_wins, :integer
    field :num_losses, :integer
    field :percent, :float
    field :played, :integer
    field :last_ninety_played, :integer
    field :last_ninety_percent, :float

    timestamps()
  end

  def create_changeset(deck, attrs) do
    deck
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end

  def update_changeset(deck, attrs) do
    deck
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> cast(
      %{
        percent: attrs.num_wins / (attrs.num_losses + attrs.num_wins),
        played: attrs.num_wins + attrs.num_losses
      },
      [:percent, :played]
    )
  end

  def ninety_changeset(deck, attrs) do
    deck
    |> cast(attrs, @ninety)
    |> validate_required(@ninety)
  end
end
