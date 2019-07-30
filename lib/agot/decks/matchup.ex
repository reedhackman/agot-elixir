defmodule Agot.Decks.Matchup do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :faction,
    :agenda,
    :oppfaction,
    :oppagenda,
    :wins,
    :losses
  ]

  @required_fields [
    :faction,
    :oppfaction
  ]

  schema "matchups" do
    field :faction, :string
    field :agenda, :string
    field :oppfaction, :string
    field :oppagenda, :string
    field :wins, :integer
    field :losses, :integer

    timestamps()
  end

  def changeset(matchup, attrs) do
    matchup
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
