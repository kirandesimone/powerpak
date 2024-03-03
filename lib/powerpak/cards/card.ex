defmodule Powerpak.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :name, :string
    field :cost, :integer
    field :ability, :string
    field :power, :integer
    field :img, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(card, attrs \\ %{}) do
    card
    |> cast(attrs, [:name, :cost, :ability, :power, :img])
    |> validate_required([:name, :cost, :ability, :power, :img])
  end
end
