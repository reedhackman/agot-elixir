defmodule Agot.Repo.Migrations.CreateGamesTable do
  use Ecto.Migration

  def change do
    create table(:tournaments) do
      add :name, :string
      add :standings, {:array, :integer}
      add :date, :utc_datetime

      timestamps()
    end

    create unique_index(:tournaments, :id)

    create table(:games) do
      add :winner_faction, :string
      add :loser_faction, :string
      add :winner_agenda, :string
      add :loser_agenda, :string
      add :tournament_date, :utc_datetime

      add :winner_id, references(:players)
      add :loser_id, references(:players)
      add :tournament_id, references(:tournaments)

      timestamps()
    end
  end
end
