defmodule Powerpak.GameUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games_users" do
    belongs_to :users, Powerpak.Accounts
    belongs_to :games, Powerpak.Games

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game_user, attrs) do
    game_user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
