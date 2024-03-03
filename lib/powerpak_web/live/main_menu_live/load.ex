defmodule PowerpakWeb.MainMenuLive.Load do
  use PowerpakWeb, :live_component

  alias Powerpak.Games

  @impl true
  def update(%{state: :loading} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)

    {:ok, socket}
  end

  def update(%{state: :entering} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> search_or_create_game()
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="load-game" phx-hook="AutoLoad">
      <p> Finding Game... </p>
    </div>
    """
  end

  defp search_or_create_game(socket) do
    # find a game that only has one player
    {:ok, current_game} = case search_for_game() do
      %Games.Game{} = game -> {:ok, game}
      _ -> Games.create_game(%{state: 1})
    end

    notify_parent(current_game.id)
    socket
  end

  defp search_for_game() do
    Games.get_loading_game()
    |> List.first()
  end


  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
