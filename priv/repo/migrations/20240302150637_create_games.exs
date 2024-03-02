defmodule Powerpak.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :state, :integer
      timestamps(type: :utc_datetime)
    end
  end
end
