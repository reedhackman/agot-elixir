defmodule Agot.Games.Incomplete do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :tournament_id,
    :id
  ]

  schema "incomplete_games" do
    field :tournament_id, :integer

    timestamps()
  end

  def changeset(incomplete_game, attrs) do
    incomplete_game
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
