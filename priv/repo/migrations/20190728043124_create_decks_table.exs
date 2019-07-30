defmodule Agot.Repo.Migrations.CreateDecksTable do
  use Ecto.Migration

  def change do
    create table(:decks) do
      add :faction, :string
      add :agenda, :string
      add :wins, :integer
      add :losses, :integer

      timestamps()
    end
  end
end
