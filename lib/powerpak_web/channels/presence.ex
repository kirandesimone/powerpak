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

  use PowerpakWeb, :html

  alias Powerpak.Games.Game
  alias Powerpak.Accounts

  @pubsub Powerpak.PubSub


  def init(_opts) do
    {:ok, %{}}
  end

  def fetch(_topic, presences) do
    users =
      presences
      |> Map.keys()
      |> Accounts.get_users_map()
      |> Enum.into(%{})

    for {key, %{metas: metas}} <- presences, into: %{} do
      {key, %{metas: metas, user: users[key]}}
    end
  end


  def handle_metas(topic, %{joins: joins, leaves: leaves}, presences, state) do
    for {user_id, presence} <- joins do
      user_data = %{user: presence.user, metas: Map.fetch!(presences, user_id)}
      msg = {__MODULE__, {:joined, user_data}}
      Phoenix.PubSub.local_broadcast(@pubsub, topic, msg)
    end

    for {user_id, presence} <- leaves do
      metas =
        case Map.fetch(presences, user_id) do
          {:ok, presence_metas} -> presence_metas
          :error -> []
        end

      user_data = %{user: presence.user, metas: metas}
      msg = {__MODULE__, {:left, user_data}}
      Phoenix.PubSub.local_broadcast(@pubsub, topic, msg)
    end

    {:ok, state}
  end

  def track_game_user(game_id, current_user_id) do
    track(
      self(),
      topic(game_id),
      current_user_id,
      %{}
    )
  end

  def untrack_game_user(game_id, current_user_id) do
    untrack(
      self(),
      topic(game_id),
      current_user_id
    )
  end

  def subscribe(game_id), do: Phoenix.PubSub.subscribe(@pubsub, topic(game_id))

  def list_game_presences(%Game{} = game) do
    list(topic(game.id))
  end

  def connected_users(assigns) do
    count = Enum.count(assigns.presence_ids)

    assigns =
      assigns
      |> assign(:count, count)
      |> assign(:total_count, fn -> count end)

    ~H"""
    <div>
      <h2 class="text-gray-500 text-xs font-medium uppercase tracking-wide">
        Connected Users (<%= @count %>)
      </h2>
      <ul
        id="connected-users"
        role="list"
        x-max="1"
        class="grid grid-cols-1 gap-4 sm:gap-4 sm:grid-cols-2 xl:grid-cols-5 mt-3"
      >
        <%= for {id, _time} <- Enum.sort(@presence_ids, fn {_, t1}, {_, t2} -> t1 < t2 end) do %>
          <li id={"presence-#{@presences[id].id}"} class="relative col-span-1 flex shadow-sm rounded-md overflow-hidden">
            <div class="flex-1 flex items-center justify-between text-gray-900 text-sm font-medium hover:text-gray-600 pl-3">
              <div class="flex-1 py-1 text-sm truncate">
                <%= @presences[id].username %>
              </div>
            </div>
          </li>
        <% end %>
      </ul>
      <%= if @total_count > @count do %>
        <p> + more </p>
      <% end %>
    </div>
    """
  end

  defp topic(game_id), do: "proxy:active_players:#{game_id}}"
end
