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
    field :percent, :float
    field :played, :integer

    has_many :wins, Game, foreign_key: :winner_id, references: :id
    has_many :losses, Game, foreign_key: :loser_id, references: :id

    timestamps()
  end

  def create_changeset(player, attrs) do
    player
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end

  def update_changeset(player, attrs) do
    player
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> cast(
      %{
        percent: attrs.num_wins / (attrs.num_losses + attrs.num_wins),
        played: attrs.num_wins + attrs.num_losses
      },
      [:percent, :played]
    )
  end
end
