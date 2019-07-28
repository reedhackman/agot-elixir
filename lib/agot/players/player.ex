defmodule Agot.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset

  alias Agot.Games.Game

  @fields [
    :name,
    :id,
    :num_wins,
    :num_losses,
    :rating
  ]

  schema "players" do
    field :name, :string
    field :num_wins, :integer
    field :num_losses, :integer
    field :rating, :float

    has_many :wins, Game, foreign_key: :winner_id, references: :id
    has_many :losses, Game, foreign_key: :loser_id, references: :id

    timestamps()
  end

  def changeset(player, attrs) do
    player
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
