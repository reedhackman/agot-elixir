defmodule Agot.Repo.Migrations.CreateExcludeTournamentsTable do
  use Ecto.Migration

  def change do
    create table(:excluded_tournaments) do
      add :tournament_name, :string

      timestamps()
    end
  end
end
