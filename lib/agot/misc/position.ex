defmodule Agot.Misc.Position do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :page_number,
    :page_length
  ]

  schema "positions" do
    field :page_number, :integer
    field :page_length, :integer

    timestamps()
  end

  def changeset(position, attrs) do
    position
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
