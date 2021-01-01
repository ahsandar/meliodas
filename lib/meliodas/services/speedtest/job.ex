defmodule Meliodas.Services.Speedtest.Job do
  use GenServer

  require Logger

  alias Meliodas.Services.Speedtest.Api

  @timeout 90_000

  def start_link(default \\ %{}) do
    GenServer.start_link(__MODULE__, default)
  end

  def init(state \\ %{}) do
    {:ok, state, @timeout}
  end

  def handle_info(:timeout, _state) do
    Logger.info("Running Speedtest....")
    {_, result} = Api.fetch()
    MeliodasWeb.Endpoint.broadcast("speedtest", "result", result)
    {:noreply, result, @timeout}
  end
end
