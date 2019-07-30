defmodule Agot.Repo.Migrations.CreateMatchupsTable do
  use Ecto.Migration

  def change do
    create table(:matchups) do
      add :faction, :string
      add :agenda, :string
      add :oppfaction, :string
      add :oppagenda, :string
      add :wins, :integer
      add :losses, :integer

      timestamps()
    end
  end
end
