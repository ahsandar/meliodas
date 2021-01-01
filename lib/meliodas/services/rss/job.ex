defmodule Meliodas.Services.Rss.Job do
  use GenServer

  require Logger

  alias Meliodas.Services.Rss.Api

  @timeout 600_000

  def start_link(default \\ %{}) do
    GenServer.start_link(__MODULE__, default)
  end

  def init(_state \\ %{}) do
    {:ok, Api.fetch(), @timeout}
  end

  def handle_info(:timeout, _state) do
    Logger.info("Fetching Rss Feed....")
    {_, feed} = Api.fetch()
    MeliodasWeb.Endpoint.broadcast("rss", "feed", feed)
    {:noreply, feed, @timeout}
  end
end
