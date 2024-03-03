defmodule PowerpakWeb.DeckLive.Index do
  alias Powerpak.Decks
  alias Powerpak.Decks.Deck
  use PowerpakWeb, :live_view


  @impl true
  def mount(_params, _session, socket) do
    %{current_user: current_user} = socket.assigns

    {:ok, assign(socket, :deck, Decks.get_deck_by_user_id(current_user.id))}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Deck")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Deck Builder")
    |> assign(:new_deck, %Deck{})
  end

  defp apply_action(socket, :edit, _params) do
    socket
  end

end
