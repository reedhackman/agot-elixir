defmodule Agot.Misc do
  alias Agot.Repo
  alias Agot.Misc.Position
  alias Agot.Misc.Exclude

  import Ecto.Query

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

  def get_excluded_tournament(id, name) do
    case list_single_excluded(id) do
      excluded ->
        Cache.put_exclude(excluded.id, %{name: excluded.name, id: excluded.id})

      nil ->
        create_excluded_tournament(id, name)
        Cache.put_exclude(id, %{name: name, id: id})
    end
  end

  def create_excluded_tournament(id, name) do
    %Exclude{}
    |> Exclude.changeset(%{id: id, name: name})
    |> Repo.insert()
    |> Kernel.elem(1)
  end

  def list_excluded_tournaments do
    Repo.all(Exclude)
  end

  def list_single_excluded(id) do
    query =
      from exclude in Exclude,
        where: exclude.id == ^id

    Repo.one(query)
  end
end
