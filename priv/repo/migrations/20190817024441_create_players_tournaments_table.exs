defmodule Agot.Repo.Migrations.CreatePlayersTournamentsTable do
  use Ecto.Migration

  def change do
    create table(:players_tournaments, primary_key: false) do
      add :player_id, references(:players), primary_key: true
      add :tournament_id, references(:tournaments), primary_key: true

      timestamps()
    end

    create index(:players_tournaments, [:player_id])
    create index(:players_tournaments, [:tournament_id])

    create unique_index(:players_tournaments, [:player_id, :tournament_id], name: :player_id_tournament_id_unique_index)
  end
end
