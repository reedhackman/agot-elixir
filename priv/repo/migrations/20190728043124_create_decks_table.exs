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
      add :last_ninety_percent, :float
      add :last_ninety_played, :integer

      timestamps()
    end
  end
end
