defmodule Powerpak.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Powerpak.Games` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{

      })
      |> Powerpak.Games.create_game()

    game
  end
end
