defmodule Powerpak.CardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Powerpak.Cards` context.
  """

  @doc """
  Generate a card.
  """
  def card_fixture(attrs \\ %{}) do
    {:ok, card} =
      attrs
      |> Enum.into(%{
        ability: "some ability",
        cost: 42,
        img: "some img",
        name: "some name",
        power: 42
      })
      |> Powerpak.Cards.create_card()

    card
  end
end
