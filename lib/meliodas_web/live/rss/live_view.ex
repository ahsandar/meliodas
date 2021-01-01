defmodule MeliodasWeb.Rss.LiveView do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    if connected?(socket), do: MeliodasWeb.Endpoint.subscribe("rss")
    {:ok, init_feed(socket)}
  end

  def handle_info(%{event: "feed", payload: feed}, socket) do
    {:noreply, assign(socket, feed: feed, updated_at: NaiveDateTime.local_now())}
  end

  def init_feed(socket) do
    {_, feed} = Meliodas.Services.Rss.Api.fetch()
    assign(socket, feed: feed, updated_at: NaiveDateTime.local_now())
  end
end
