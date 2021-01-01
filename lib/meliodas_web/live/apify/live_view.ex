defmodule MeliodasWeb.Apify.LiveView do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    if connected?(socket), do: MeliodasWeb.Endpoint.subscribe("apify")
    {:ok, init_count(socket)}
  end

  def handle_info(%{event: "covid19", payload: count}, socket) do
    {:noreply, assign(socket, count: count, updated_at: NaiveDateTime.local_now())}
  end

  def init_count(socket) do
    {_, count} = Meliodas.Services.Apify.Api.fetch()
    assign(socket, count: count, updated_at: NaiveDateTime.local_now())
  end
end
