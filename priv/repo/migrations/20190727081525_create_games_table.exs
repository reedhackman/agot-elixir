defmodule Agot.Repo.Migrations.CreateGamesTable do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :winner_faction, :string
      add :loser_faction, :string
      add :winner_agenda, :string
      add :loser_agenda, :string
      add :tournament_id, :integer
      add :game_id, :integer
      add :tournament_date, :utc_datetime

      add :winner_id, references(:players)
      add :loser_id, references(:players)

      timestamps()
    end
  end
end
