defmodule Agot.Repo.Migrations.CreateDecksTable do
  use Ecto.Migration

  def change do
    create table(:decks) do
      add :faction, :string
      add :agenda, :string
      add :num_wins, :integer
      add :num_losses, :integer
      add :percent, :float
      add :played, :integer

      timestamps()
    end
  end
end
