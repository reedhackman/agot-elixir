defmodule Agot.Repo.Migrations.CreatePlayersTable do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :num_wins, :integer
      add :num_losses, :integer
      add :rating, :float

      timestamps()
    end
  end
end
