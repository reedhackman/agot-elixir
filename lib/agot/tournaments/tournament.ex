defmodule Agot.Tournaments.Tournament do
  use Ecto.Schema
  import Ecto.Changeset

  alias Agot.Games.Game
  alias Agot.Players.Player

  @fields [
    :name,
    :id,
    :standings,
    :date
  ]

  @required_fields [
    :name,
    :id
  ]

  schema "tournaments" do
    field :name, :string
    field :standings, {:array, :integer}
    field :date, :utc_datetime

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
    |> change()
    |> put_assoc(:players, [player])
  end
end
