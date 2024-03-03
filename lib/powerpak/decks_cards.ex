defmodule Powerpak.DecksCards do
  alias Powerpak.Cards
  alias Powerpak.Decks
  use Ecto.Schema
  import Ecto.Changeset

  schema "deck_cards" do
    belongs_to :decks, Decks.Deck
    belongs_to :cards, Cards.Card

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(decks_cards, attrs) do
    decks_cards
    |> cast(attrs, [])
    |> validate_required([])
  end
end
