defmodule Meliodas.Services.Forex.Job do
  use GenServer

  require Logger

  alias Meliodas.Services.Forex.Api

  @timeout 4500_000

  def start_link(default \\ %{}) do
    GenServer.start_link(__MODULE__, default)
  end

  def init(_state \\ %{}) do
    {:ok, Api.fetch(), @timeout}
  end

  def handle_info(:timeout, _state) do
    Logger.info("Fetching Forex....")
    {_, rates} = Api.fetch()
    MeliodasWeb.Endpoint.broadcast("forex", "rates", rates)
    {:noreply, rates, @timeout}
  end
end
