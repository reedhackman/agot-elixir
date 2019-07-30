defmodule Agot.Decks.Deck do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :faction,
    :agenda,
    :wins,
    :losses
  ]

  @required_fields [
    :faction
  ]

  schema "decks" do
    field :faction, :string
    field :agenda, :string
    field :wins, :integer
    field :losses, :integer

    timestamps()
  end

  def changeset(deck, attrs) do
    deck
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
