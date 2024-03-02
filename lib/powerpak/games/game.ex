defmodule Powerpak.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :state, Ecto.Enum, values: [loading: 1, playing: 2, finished: 3], default: :loading

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [])
    |> validate_required([])
  end
end
