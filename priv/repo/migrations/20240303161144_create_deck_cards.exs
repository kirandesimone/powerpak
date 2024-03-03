defmodule Powerpak.Repo.Migrations.CreateDeckCards do
  use Ecto.Migration

  def change do
    create table(:deck_cards, primary_key: false) do
      add :deck_id, references(:decks)
      add :card_id, references(:cards)
      timestamps(type: :utc_datetime)
    end
  end
end
