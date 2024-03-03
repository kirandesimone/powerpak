defmodule PowerpakWeb.DeckLive.DeckBuilder do
  alias Powerpak.Decks
  use PowerpakWeb, :live_component

  def update(%{deck: deck} = assigns, socket) do
    changeset = Decks.change_deck(deck)
    IO.inspect(deck)
    socket =
      socket
      |> assign(assigns)
      |> assign_form(changeset)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <h2> Create Deck </h2>
      </.header>

      <.simple_form
        for={@form}
        id="deck-form"
        phx-target={@myself}
        phx-submit="save"
      >
        <.input field={@form[:name]} label="Name"/>
        <:actions>
          <.button phx-disable-with="Saving...">Save Deck</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  defp assign_form(socket, deck) do
    assign(socket, :form, to_form(deck))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
