defmodule Agot.Repo.Migrations.CreatePositionTable do
  use Ecto.Migration

  def change do
    create table(:position) do
      add :page_number, :integer
      add :page_length, :integer

      timestamps()
    end
  end
end
