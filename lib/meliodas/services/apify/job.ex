defmodule Meliodas.Services.Apify.Job do
  use GenServer

  require Logger

  alias Meliodas.Services.Apify.Api

  @timeout 600_000

  def start_link(default \\ %{}) do
    GenServer.start_link(__MODULE__, default)
  end

  def init(_state \\ %{}) do
    {:ok, Api.fetch(), @timeout}
  end

  def handle_info(:timeout, _state) do
    Logger.info("Fetching Apify....")
    {_, count} = Api.fetch()
    MeliodasWeb.Endpoint.broadcast("apify", "covid19", count)
    {:noreply, count, @timeout}
  end
end
