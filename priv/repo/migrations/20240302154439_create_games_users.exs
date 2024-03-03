defmodule Powerpak.Repo.Migrations.CreateGamesUsers do
  use Ecto.Migration

  def change do
    create table(:games_users, primary_key: false) do
      add :user_id, references(:users)
      add :game_id, references(:games)

      timestamps(type: :utc_datetime)
    end
  end
end
