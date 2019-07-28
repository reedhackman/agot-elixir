defmodule Agot.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  alias Agot.Players.Player

  @fields [
    :winner_faction,
    :winner_agenda,
    :loser_faction,
    :loser_agenda,
    :tournament_id,
    :tournament_date,
    :id,
  ]

  @required_fields [
    :tournament_id,
    :tournament_date,
    :id,
  ]

  schema "games" do
    field :winner_faction, :string
    field :winner_agenda, :string
    field :loser_faction, :string
    field :loser_agenda, :string
    field :tournament_id, :integer
    field :tournament_date, :utc_datetime

    belongs_to :winner, Player
    belongs_to :loser, Player

    timestamps()
  end

  def changeset(game, attrs, winner, loser) do
    game
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> put_assoc(:winner, winner)
    |> put_assoc(:loser, loser)
  end
end
