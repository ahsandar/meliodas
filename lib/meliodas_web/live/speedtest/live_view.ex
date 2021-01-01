defmodule MeliodasWeb.Speedtest.LiveView do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    if connected?(socket), do: MeliodasWeb.Endpoint.subscribe("speedtest")
    {:ok, init_result(socket)}
  end

  def handle_info(%{event: "result", payload: result}, socket) do
    {:noreply, assign(socket, result: result, updated_at: NaiveDateTime.local_now())}
  end

  def init_result(socket) do
    assign(socket,
      result: %{
        isp: "...",
        latency: "...",
        jitter: "...",
        upload: "...",
        download: "..."
      },
      updated_at: NaiveDateTime.local_now()
    )
  end
end
