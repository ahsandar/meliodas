defmodule MeliodasWeb.Weather.LiveView do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    if connected?(socket), do: MeliodasWeb.Endpoint.subscribe("wttr")
    {:ok, init_forecast(socket)}
  end

  def handle_info(
        %{event: "forecast", payload: forecast},
        socket
      ) do
    {:noreply, assign(socket, forecast: forecast, updated_at: NaiveDateTime.local_now())}
  end

  defp init_forecast(socket) do
    {_, forecast} = Meliodas.Services.Wttr.Api.fetch()
    assign(socket, forecast: forecast, updated_at: NaiveDateTime.local_now())
  end
end
