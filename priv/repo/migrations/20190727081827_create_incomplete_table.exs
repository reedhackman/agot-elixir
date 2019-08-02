defmodule Agot.Repo.Migrations.CreateIncompleteTable do
  use Ecto.Migration

  def change do
    create table(:incomplete_games) do
      add :tournament_id, :integer

      timestamps()
    end
  end
end
