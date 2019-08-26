defmodule Agot.Misc.Exclude do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :id,
    :name
  ]

  schema "excluded_tournaments" do
    field :name, :string

    timestamps()
  end

  def changeset(excluded, attrs) do
    excluded
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
