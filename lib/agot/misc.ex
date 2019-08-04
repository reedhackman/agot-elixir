defmodule Agot.Misc do
  alias Agot.Repo
  alias Agot.Misc.Position
  alias Agot.Misc.Exclude

  def create_position() do
    %Position{}
    |> Position.changeset(%{page_number: 1, page_length: 0})
    |> Repo.insert()
    |> Kernel.elem(1)
  end

  def get_position() do
    case Repo.one(Position) do
      nil ->
        create_position()
      position ->
        position
    end
  end

  def update_position(attrs) do
    position = Repo.one(Position)
    if position.page_number == attrs.page_number and position.page_length == attrs.page_length do
      nil
    else
      position
      |> Position.changeset(attrs)
      |> Repo.update()
    end
  end

  def create_excluded_tournament(id, name) do
    "a"
  end

  def list_excluded_tournaments do
    Repo.all(Exclude)
  end
end
