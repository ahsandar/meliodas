defmodule MeliodasWeb.Clock.LiveView do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, init_clock(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, init_clock(socket)}
  end

  defp init_clock(socket) do
    assign(socket, date: NaiveDateTime.local_now())
  end
end
