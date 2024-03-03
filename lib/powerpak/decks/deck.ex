defmodule Powerpak.Decks.Deck do
  use Ecto.Schema
  import Ecto.Changeset

  schema "decks" do
    field :name, :string

    #many_to_many :cards, Powerpak.Cards.Card,
      #join_through: Powerpak.DecksCards

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(deck, attrs) do
    deck
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
