defmodule Powerpak.DecksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Powerpak.Decks` context.
  """

  @doc """
  Generate a deck.
  """
  def deck_fixture(attrs \\ %{}) do
    {:ok, deck} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Powerpak.Decks.create_deck()

    deck
  end
end
