defmodule Agot.Repo.Migrations.AddColumnToPlayers do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :ratings_over_time, :map
    end
  end
end
