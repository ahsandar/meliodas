defmodule Meliodas.Services.Wttr.Job do
  use GenServer

  require Logger

  alias Meliodas.Services.Wttr.Api

  @timeout 600_000

  def start_link(default \\ %{}) do
    GenServer.start_link(__MODULE__, default)
  end

  def init(_state \\ %{}) do
    {:ok, Api.fetch(), @timeout}
  end

  def handle_info(:timeout, _state) do
    Logger.info("Fetching wttr....")
    {_, forecast} = Api.fetch()
    MeliodasWeb.Endpoint.broadcast("wttr", "forecast", forecast)
    {:noreply, forecast, @timeout}
  end
end
