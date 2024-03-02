defmodule PowerpakWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :powerpak,
    pubsub_server: Powerpak.PubSub,
    presence: __MODULE__

  @pubsub PowerPak.PubSub


  def init(_opts) do
    {:ok, %{}}
  end

  def fetch(_topic, presences) do

  end


  def handle_metas(topic, %{joins: joins, leaves: leaves}, presences, state) do
    for {user_id, presence} <- joins do
      user_data = %{id: user_id, user: presence.user, metas: Map.fetch!(presences, user_id)}
      msg = {__MODULE__, {:joined, user_data}}
      Phoenix.PubSub.local_broadcast(@pubsub, topic(topic), msg)
    end

    for {user_id, presence} <- leaves do
      metas =
        case Map.fetch(presences, user_id) do
          {:ok, presence_metas} -> presence_metas
          :error -> []
        end

      user_data = %{id: user_id, user: presence.user, metas: metas}
      msg = {__MODULE__, {:left, user_data}}
      Phoenix.PubSub.local_broadcast(@pubsub, topic(topic), msg)
    end

    {:ok, state}
  end

  def track_game_user(topic, current_user_id) do
    track(
      self(),
      topic(topic),
      current_user_id,
      %{}
    )
  end

  def untrack_game_user() do

  end


  defp topic(name), do: "proxy:#{name}"
end
