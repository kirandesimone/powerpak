defmodule PowerpakWeb.GameLive.Index do
  use PowerpakWeb, :live_view

  alias PowerpakWeb.Presence
  alias Powerpak.Games

  @max_presences 2

  @impl true
  def mount(%{"id" => game_id}, _session, socket) do
    %{current_user: current_user} = socket.assigns

    IO.inspect(current_user)
    game = Games.get_game!(game_id)

    socket =
      socket
      |> assign(game: game)
      |> assign_presences()

    if connected?(socket) do
      Presence.subscribe(game_id)
      Presence.track_game_user(game_id, current_user.id)
    end

    {:ok, socket}
  end

  def handle_info(%Phoenix.Socket.Broadcast{topic: _topic, event: _event, payload: _payload}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({PowerpakWeb.Presence, {:joined, joins}}, socket) do
    socket =
      socket
      |> assign_presence(joins)

    {:noreply, socket}
  end

  @impl true
  def handle_info({PowerpakWeb.Presence, {:left, leaves}}, socket) do
    %{user: user} = leaves

    if leaves.metas == [] do
      socket = socket |> remove_presence(user)
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  defp assign_presences(socket) do
    socket = assign(socket, presences: %{}, presence_ids: %{}, presence_count: 0)

    # This will return the game in socket since it's the last in the cond
    if game = connected?(socket) && socket.assigns.game do
      game
      |> Presence.list_game_presences()
      |> Enum.reduce(socket, fn {_id, presence}, acc -> assign_presence(acc, presence) end)
    else
      socket
    end

  end

  defp assign_presence(socket, metas) do
    %{user: user} = metas
    %{presence_ids: presence_ids} = socket.assigns

    cond do
      Map.has_key?(presence_ids, user.id) ->
        socket

      Enum.count(presence_ids) < @max_presences ->
        socket
        |> update(:presences, &Map.put(&1, user.id, user))
        |> update(:presence_ids, &Map.put(&1, user.id, System.system_time()))
        |> update(:presence_count, &(&1 + 1))

      true ->
        update(socket, :presence_count, &(&1 + 1))
    end
  end


  defp remove_presence(socket, user) do
    socket
    |> update(:presences, &Map.delete(&1, user.id))
    |> update(:presence_ids, &Map.delete(&1, user.id))
    |> update(:presence_count, &(&1 - 1))
  end

end
