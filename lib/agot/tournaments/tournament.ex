defmodule Agot.Tournaments.Tournament do
  use Ecto.Schema
  import Ecto.Changeset

  alias Agot.Games.Game
  alias Agot.Players.Player

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
    field :player_placements, {:array, :integer}

    has_many :games, Game
    many_to_many :players, Player, join_through: "players_tournaments"

    timestamps()
  end

  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end

  def player_changeset(tournament, player) do
    tournament
    |> put_assoc(:players, player)
  end
end
