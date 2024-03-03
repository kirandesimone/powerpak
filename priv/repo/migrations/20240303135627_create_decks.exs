defmodule Powerpak.Repo.Migrations.CreateDecks do
  use Ecto.Migration

  def change do
    create table(:decks) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
