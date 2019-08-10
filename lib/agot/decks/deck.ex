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

  schema "decks" do
    field :faction, :string
    field :agenda, :string
    field :num_wins, :integer
    field :num_losses, :integer
    field :percent, :float
    field :played, :integer

    timestamps()
  end

  def create_changeset(deck, attrs) do
    deck
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end

  def update_changeset(deck, attrs) do
    IO.inspect(attrs)
    IO.inspect(deck)

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
end
