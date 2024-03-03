defmodule Powerpak.Repo.Migrations.AddUseridForeignKeyToDecks do
  use Ecto.Migration

  def change do
    alter table("decks") do
      add :user_id, references(:users)
    end
  end
end
