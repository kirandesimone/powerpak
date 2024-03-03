defmodule PowerpakWeb.MainMenuLive.Index do
  alias PowerpakWeb.MainMenuLive
  use PowerpakWeb, :live_view


  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, state: :loading)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({MainMenuLive.Load, game_id}, socket) do
    socket =
      socket
      |> push_navigate(to: ~p"/game/#{game_id}")

    {:noreply, socket}
  end

  @impl true
  def handle_event("load", _unsigned_params, socket) do
    send_update(MainMenuLive.Load, id: :load, state: :entering)
    {:noreply, socket}
  end

  def apply_action(socket, :load, _params) do
    assign(socket, :page_title, "Searching for Opponent")
  end

  def apply_action(socket, :index, _params) do
    assign(socket, :page_title, "Main Menu")
  end

end
