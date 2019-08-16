defmodule Agot.Tournaments.Tournament do
  use Ecto.Schema
  import Ecto.Changeset

  alias Agot.Games.Game

  @fields [
    :tournament_name,
    :id,
    :player_placements
  ]

  @required_fields [
    :tournament_name,
    :id
  ]

  schema "tournaments" do
    field :tournament_name, :string
    field :player_placements, :map

    has_many :games, Game

    timestamps()
  end

  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
